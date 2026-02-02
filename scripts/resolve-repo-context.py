#!/usr/bin/env python3
"""
Repository Context Resolver

Extracts owner and repo information from config/repositories.json URLs.
Enables smart context resolution for GitHub MCP operations.

Usage:
    python scripts/resolve-repo-context.py <repo_name>
    python scripts/resolve-repo-context.py --list
    python scripts/resolve-repo-context.py --json <repo_name>

Examples:
    python scripts/resolve-repo-context.py dbt_cloud
    # Output: your-org dbt_cloud

    python scripts/resolve-repo-context.py --json dbt_cloud
    # Output: {"owner": "your-org", "repo": "dbt_cloud", "url": "...", "branch": "..."}
"""

import json
import sys
import re
from pathlib import Path
from typing import Dict, Optional, Tuple


def load_repositories_config() -> Dict:
    """Load repositories.json configuration file."""
    config_path = Path(__file__).parent.parent / "config" / "repositories.json"

    if not config_path.exists():
        print(f"Error: {config_path} not found", file=sys.stderr)
        sys.exit(1)

    with open(config_path) as f:
        return json.load(f)


def extract_owner_repo(url: str) -> Optional[Tuple[str, str]]:
    """
    Extract owner and repo name from GitHub URL.

    Args:
        url: GitHub URL (https://github.com/owner/repo.git)

    Returns:
        Tuple of (owner, repo) or None if not a GitHub URL
    """
    if url == "local":
        return None

    # Match GitHub URLs: https://github.com/owner/repo.git
    match = re.match(r'https://github\.com/([^/]+)/([^/]+?)(?:\.git)?$', url)
    if match:
        return match.group(1), match.group(2)

    return None


def find_repo_info(config: Dict, repo_name: str) -> Optional[Dict]:
    """
    Find repository information by name.

    Args:
        config: Loaded repositories.json config
        repo_name: Name of repository to find

    Returns:
        Dict with owner, repo, url, branch, description or None if not found
    """
    # Search through all sections (knowledge, data_stack layers)
    for section_key, section_value in config.items():
        if section_key.startswith("_") or section_key == "settings" or section_key == "prefect_context":
            continue

        # Handle direct repos in section (like knowledge section)
        if isinstance(section_value, dict):
            # Check if this repo is directly in this section
            if repo_name in section_value and isinstance(section_value[repo_name], dict) and "url" in section_value[repo_name]:
                repo_config = section_value[repo_name]
                owner_repo = extract_owner_repo(repo_config["url"])
                if owner_repo:
                    owner, repo = owner_repo
                    return {
                        "owner": owner,
                        "repo": repo,
                        "url": repo_config["url"],
                        "branch": repo_config.get("branch", "main"),
                        "description": repo_config.get("description", ""),
                        "folder": repo_config.get("folder", ""),
                    }

            # Also check nested structure (like data_stack with layers)
            for subsection_key, subsection_value in section_value.items():
                if subsection_key.startswith("_"):
                    continue

                # Check if this level has repos
                if isinstance(subsection_value, dict):
                    for key, repo_config in subsection_value.items():
                        if key == repo_name and isinstance(repo_config, dict) and "url" in repo_config:
                            owner_repo = extract_owner_repo(repo_config["url"])
                            if owner_repo:
                                owner, repo = owner_repo
                                return {
                                    "owner": owner,
                                    "repo": repo,
                                    "url": repo_config["url"],
                                    "branch": repo_config.get("branch", "main"),
                                    "description": repo_config.get("description", ""),
                                    "folder": repo_config.get("folder", ""),
                                }

    return None


def list_all_repos(config: Dict) -> Dict[str, Dict]:
    """
    List all repositories with their context information.

    Returns:
        Dict mapping repo_name -> repo_info
    """
    repos = {}

    for section_key, section_value in config.items():
        if section_key.startswith("_") or section_key == "settings" or section_key == "prefect_context":
            continue

        if isinstance(section_value, dict):
            for subsection_key, subsection_value in section_value.items():
                if subsection_key.startswith("_"):
                    continue

                if isinstance(subsection_value, dict):
                    for key, repo_config in subsection_value.items():
                        if isinstance(repo_config, dict) and "url" in repo_config:
                            owner_repo = extract_owner_repo(repo_config["url"])
                            if owner_repo:
                                owner, repo = owner_repo
                                repos[key] = {
                                    "owner": owner,
                                    "repo": repo,
                                    "url": repo_config["url"],
                                    "branch": repo_config.get("branch", "main"),
                                    "description": repo_config.get("description", ""),
                                    "folder": repo_config.get("folder", ""),
                                }

    return repos


def main():
    if len(sys.argv) < 2:
        print("Usage: resolve-repo-context.py <repo_name>", file=sys.stderr)
        print("       resolve-repo-context.py --list", file=sys.stderr)
        print("       resolve-repo-context.py --json <repo_name>", file=sys.stderr)
        sys.exit(1)

    config = load_repositories_config()

    # Handle --list flag
    if sys.argv[1] == "--list":
        repos = list_all_repos(config)
        for repo_name, info in sorted(repos.items()):
            print(f"{repo_name}: {info['owner']}/{info['repo']} ({info['branch']})")
        sys.exit(0)

    # Handle --json flag
    if sys.argv[1] == "--json":
        if len(sys.argv) < 3:
            print("Error: --json requires repo_name argument", file=sys.stderr)
            sys.exit(1)

        repo_name = sys.argv[2]
        repo_info = find_repo_info(config, repo_name)

        if repo_info:
            print(json.dumps(repo_info, indent=2))
            sys.exit(0)
        else:
            print(json.dumps({"error": f"Repository '{repo_name}' not found"}), file=sys.stderr)
            sys.exit(1)

    # Default: return owner and repo space-separated
    repo_name = sys.argv[1]
    repo_info = find_repo_info(config, repo_name)

    if repo_info:
        print(f"{repo_info['owner']} {repo_info['repo']}")
        sys.exit(0)
    else:
        print(f"Error: Repository '{repo_name}' not found in config/repositories.json", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
