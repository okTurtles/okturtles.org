'use strict'

export function sortedPosts(posts) {
  return posts.sort((a, b) => {
    const aDate = new Date(a.frontmatter.pubDate || a.frontmatter.date)
    const bDate = new Date(b.frontmatter.pubDate || b.frontmatter.date)
    return bDate.getTime() - aDate.getTime()
  })
}
