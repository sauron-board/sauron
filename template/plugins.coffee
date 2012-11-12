module.exports =
  "army-of-one-github-commits":
    displayName: "Github Commits"
    package: "sauron-github-commits"
    config:
      githubToken: process.env.GITHUB_USER_TOKEN
      repos: [
        "nko3/army-of-one"
      ]
