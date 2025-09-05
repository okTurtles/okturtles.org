'use strict'

export function sortedPosts(posts, sortBy = 'latest') {
  return posts.sort((a, b) => {
    const aDate = new Date(a.frontmatter.pubDate || a.frontmatter.date).getTime()
    const bDate = new Date(b.frontmatter.pubDate || b.frontmatter.date).getTime()
    return sortBy === 'latest'
      ? bDate - aDate
      : aDate - bDate
  })
}

export function getAllJobs(sortBy = 'latest') {
  const allPosts = Object.values(import.meta.glob('./content/jobs/*.{md,mdx}', { eager: true }))
  return sortedPosts(allPosts, sortBy)
}
