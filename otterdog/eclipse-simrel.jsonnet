local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('technology.simrel', 'eclipse-simrel') {
  settings+: {
    blog: "https://ci.eclipse.org/simrel",
    description: "SimRel provides infrastructure for coordinating the release of projects used to build Eclipse IDE/RCP applications.",
    discussion_source_repository: "eclipse-simrel/simrel.build",
    email: "cross-project-issues-dev@eclipse.org",
    has_discussions: true,
    name: "Eclipse Simultaneous Release",
    web_commit_signoff_required: false,
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },
  teams+: [
    orgs.newTeam('technology-simrel-release-managers') {
      members+: [
        "fredg02",
        "merks"
      ],
    },
  ],
  webhooks+: [
    orgs.newOrgWebhook('https://ci.eclipse.org/simrel/github-webhook/') {
      content_type: "json",
      events+: [
        "pull_request",
        "push"
      ],
    },
  ],
  _repositories+:: [
    orgs.newRepo('.github') {
      allow_merge_commit: true,
      allow_update_branch: false,
      delete_branch_on_merge: false,
      description: "Global configurations for the eclipse-simrel GitHub organization.",
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          bypass_pull_request_allowances+: [
            "@fredg02",
            "@merks"
          ],
          required_approving_review_count: 0,
          requires_status_checks: false,
          requires_strict_status_checks: true,
        },
      ],
    },
    orgs.newRepo('help.eclipse.org') {
      allow_merge_commit: true,
      allow_update_branch: false,
      delete_branch_on_merge: false,
      description: "Infocenter hosted at help.eclipse.org",
      homepage: "https://help.eclipse.org",
      topics+: [
        "documentation",
        "eclipse",
        "eclipse-ide",
        "help"
      ],
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          bypass_pull_request_allowances+: [
            "@fredg02",
            "@merks"
          ],
          required_approving_review_count: 0,
          requires_status_checks: false,
          requires_strict_status_checks: true,
        },
      ],
    },
    orgs.newRepo('simrel.build') {
      allow_auto_merge: true,
      allow_update_branch: false,
      description: "The aggregation model and build infrastructure.",
      has_discussions: true,
      web_commit_signoff_required: false,
      rulesets: [
        orgs.newRepoRuleset('main') {
          bypass_actors+: [
            "@eclipse-simrel/technology-simrel-release-managers"
          ],
          include_refs+: [
            "refs/heads/main"
          ],
          required_pull_request+: {
            dismisses_stale_reviews: true,
            required_approving_review_count: 0,
          },
          required_status_checks+: {
            status_checks+: [
              "continuous-integration/jenkins/pr-head"
            ],
          },
        },
      ],
    },
    orgs.newRepo('simrel.tools') {
      allow_update_branch: false,
      delete_branch_on_merge: false,
      description: "Utilities and tools for maintenance.",
      web_commit_signoff_required: false,
      workflows+: {
        enabled: false,
      },
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          bypass_pull_request_allowances+: [
            "@fredg02",
            "@merks"
          ],
          required_approving_review_count: 0,
          requires_status_checks: false,
          requires_strict_status_checks: true,
        },
      ],
    },
  ],
}
