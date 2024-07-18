// claxpoint
import * as fs from 'fs'; // File system access
import { relative } from 'path'; // Path manipulation

const repoPath = '/path/to/your/cloned/repo'; // you can use your own repo-sys

/**
 * Sorts files within a directory based on the provided sorting function.
 * @param dirPath The directory path to sort files within.
 * @param sortFn The sorting function to use (e.g., compare filenames alphabetically).
 */
async function sortFiles(dirPath: string, sortFn: (a: string, b: string) => number) {
  const files = await fs.promises.readdir(dirPath);
  const sortedFiles = files.sort(sortFn);

  console.log('Sorted files:');
  for (const file of sortedFiles) {
    console.log(relative(repoPath, dirPath) + '/' + file);
  }
}

function compareFiles(a: string, b: string): number {
  return a.localeCompare(b);
}

sortFiles(repoPath, compareFiles);
