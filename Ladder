#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <time.h>

typedef struct WordNode_struct {
    char* myWord;
    struct WordNode_struct* next; 
} WordNode;

typedef struct LadderNode_struct {
    WordNode* topWord;
    struct LadderNode_struct* next; 
} LadderNode;

int compareWord(const void* a, const void* b) {
    const char* A = *(const char**)a;
    const char* B = *(const char**)b;
    return strcmp(A, B);
}

int countWordsOfLength(char* filename, int wordSize) { 
    FILE* fileBuffer = fopen(filename, "r");
    if (fileBuffer == NULL) {
        return -1;
    }
    int count = 0;
    char word[100];
    while (fscanf(fileBuffer, "%99s", word) == 1) {
        if (strlen(word) == wordSize) {
            count++;
        }
    }
    fclose(fileBuffer);
    return count;
}

bool buildWordArray(char* filename, char** words, int numWords, int wordSize) { 
    FILE* fileBuffer = fopen(filename, "r");
    if (fileBuffer == NULL) {
        return false;
    }
    int count = 0;
    char word[100];
    while (fscanf(fileBuffer, "%99s", word) == 1) {
        if (strlen(word) == wordSize) {
            if (count >= numWords) {
                fclose(fileBuffer);
                return false;
            }
            strcpy(words[count], word);
            count++;
        }
    }
    fclose(fileBuffer);
    if (count != numWords) {
        return false;
    }
    qsort(words, numWords, sizeof(char*), compareWord);
    return true;
}

int findWord(char** words, char* aWord, int loInd, int hiInd) { 
    while (loInd <= hiInd) {
        int mid = loInd + (hiInd - loInd) / 2;
        int cmp = strcmp(words[mid], aWord);
        if (cmp == 0) {
            return mid;
        } else if (cmp < 0) {
            loInd = mid + 1;
        } else {
            hiInd = mid - 1;
        }
    }
    return -1;
}

void freeWords(char** words, int numWords) {
    for (int i = 0; i < numWords; ++i) {
        free(words[i]);
    }
    free(words);
}

void insertWordAtFront(WordNode** ladder, char* newWord) {
    WordNode* newNode = (WordNode*)malloc(sizeof(WordNode));
    if (newNode == NULL) {
        fprintf(stderr, "Allocation Failure\n");
        exit(EXIT_FAILURE);
    }
    newNode->myWord = newWord;
    newNode->next = *ladder;
    *ladder = newNode;
}

int getLadderHeight(WordNode* ladder) {
    int height = 0;
    while (ladder != NULL) {
        height++;
        ladder = ladder->next;
    }
    return height;
}

WordNode* copyLadder(WordNode* ladder) {
    if (ladder == NULL) {
        return NULL;
    }
    WordNode* newLadder = NULL;
    WordNode* tail = NULL;
    WordNode* curr = ladder;
    while (curr != NULL) {
        WordNode* newNode = (WordNode*)malloc(sizeof(WordNode));
        if (newNode == NULL) {
            fprintf(stderr, "Allocation Failure\n");
            exit(EXIT_FAILURE);
        }
        newNode->myWord = curr->myWord;
        newNode->next = NULL;
        if (newLadder == NULL) {
            newLadder = newNode;
            tail = newNode;
        } else {
            tail->next = newNode;
            tail = newNode;
        }
        curr = curr->next;
    }
    return newLadder;
}

void freeLadder(WordNode* ladder) {
    WordNode* curr = ladder;
    while (curr != NULL) {
        WordNode* temp = curr;
        curr = curr->next;
        free(temp);
    }
}

void insertLadderAtBack(LadderNode** list, WordNode* newLadder) {
    LadderNode* newNode = (LadderNode*)malloc(sizeof(LadderNode));
    if (newNode == NULL) {
        fprintf(stderr, "Allocation Failure\n");
        exit(EXIT_FAILURE);
    }
    newNode->topWord = newLadder;
    newNode->next = NULL;
    if (*list == NULL) {
        *list = newNode;
    } else {
        LadderNode* curr = *list;
        while (curr->next != NULL) {
            curr = curr->next;
        }
        curr->next = newNode;
    }
}

WordNode* popLadderFromFront(LadderNode** list) {
    if (*list == NULL) {
        return NULL;
    }
    LadderNode* headNode = *list;
    WordNode* ladder = headNode->topWord;
    *list = headNode->next;
    free(headNode);
    return ladder;
}

void freeLadderList(LadderNode* listBuffer) {
    LadderNode* curr = listBuffer;
    while (curr != NULL) {
        LadderNode* temp = curr;
        curr = curr->next;
        freeLadder(temp->topWord);
        free(temp);
    }
}

WordNode* findShortestWordLadder(char** words, bool* usedWord, int numWords, int wordSize, char* startWord, char* finalWord) {
    LadderNode* listBuffer = NULL;
    WordNode* initialLadder = NULL;
    insertWordAtFront(&initialLadder, startWord);
    int startIndex = findWord(words, startWord, 0, numWords - 1);
    if (startIndex >= 0) {
        usedWord[startIndex] = true;
    }
    insertLadderAtBack(&listBuffer, initialLadder);
    while (listBuffer != NULL) {
        WordNode* currentLadder = popLadderFromFront(&listBuffer);
        WordNode* topWordNode = currentLadder;
        if (topWordNode == NULL) {
            continue;
        }
        char* topWord = topWordNode->myWord;
        for (int i = 0; i < wordSize; i++) {
            char originalChar = topWord[i];
            for (char c = 'a'; c <= 'z'; c++) {
                if (c == originalChar) {
                    continue;
                }
                char newWord[wordSize + 1];
                strcpy(newWord, topWord);
                newWord[i] = c;
                newWord[wordSize] = '\0';
                int index = findWord(words, newWord, 0, numWords - 1);
                if (index >= 0 && !usedWord[index]) {
                    if (strcmp(words[index], finalWord) == 0) {
                        insertWordAtFront(&currentLadder, words[index]);
                        freeLadderList(listBuffer);
                        return currentLadder;
                    } else {
                        usedWord[index] = true;
                        WordNode* anotherLadder = copyLadder(currentLadder);
                        insertWordAtFront(&anotherLadder, words[index]);
                        insertLadderAtBack(&listBuffer, anotherLadder);
                    }
                }
            }
        }
        freeLadder(currentLadder);
    }
    freeLadderList(listBuffer);
    return NULL;
}

void setWord(char** words, int numWords, int wordSize, char* aWord) {
    bool valid = false;
    printf("  Enter a %d-letter word: ", wordSize);
    int count = 0;
    while (!valid) {
        scanf("%s", aWord);
        count++;
        valid = (strlen(aWord) == wordSize);
        if (valid) {
            int wordInd = findWord(words, aWord, 0, numWords - 1);
            if (wordInd < 0) {
                valid = false;
                printf("    Entered word %s is not in the dictionary.\n", aWord);
                printf("  Enter a %d-letter word: ", wordSize);
            }
        } else {
            printf("    Entered word %s is not a valid %d-letter word.\n", aWord, wordSize);
            printf("  Enter a %d-letter word: ", wordSize);
        }
        if (!valid && count >= 5) {
            printf("\n");
            printf("  Picking a random word for you...\n");
            strcpy(aWord, words[rand() % numWords]);
            printf("  Your word is: %s\n", aWord);
            valid = true;
        }
    }
}

void printLadder(WordNode* ladder) {
    WordNode* currNode = ladder;
    while (currNode != NULL) {
        printf("\t\t\t%s\n", currNode->myWord);
        currNode = currNode->next;
    }
}

void printList(LadderNode* list) {
    printf("\n");
    printf("Printing the full list of ladders:\n");
    LadderNode* currList = list;
    while (currList != NULL) {
        printf("  Printing a ladder:\n");
        printLadder(currList->topWord);
        currList = currList->next;
    }
    printf("\n");
}

int main() {
    srand((unsigned int)time(0));
    printf("\nWelcome to the CS 211 Word Ladder Generator!\n\n");
    int wordSize;
    printf("Enter the word size for the ladder: ");
    scanf("%d", &wordSize);
    printf("\n");
    printf("This program will make the shortest possible\n");
    printf("word ladder between two %d-letter words.\n\n", wordSize);
    char dict[100];
    printf("Enter filename for dictionary: ");
    scanf("%s", dict);
    printf("\n");
    int numWords = countWordsOfLength(dict, wordSize);
    while (numWords < 0) {
        printf("  Dictionary %s not found...\n", dict);
        printf("Enter filename for dictionary: ");
        scanf("%s", dict);
        printf("\n");
        numWords = countWordsOfLength(dict, wordSize);
    }
    char** words = (char**)malloc(numWords * sizeof(char*));
    if (words == NULL) {
        fprintf(stderr, "Memory allocation failed for words array.\n");
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < numWords; ++i) {
        words[i] = (char*)malloc((wordSize + 1) * sizeof(char));
        if (words[i] == NULL) {
            fprintf(stderr, "Memory allocation failed for word %d.\n", i);
            for (int j = 0; j < i; ++j) {
                free(words[j]);
            }
            free(words);
            exit(EXIT_FAILURE);
        }
    }
    if (numWords < 2) {
        printf("  Dictionary %s contains insufficient %d-letter words...\n", dict, wordSize);
        printf("Terminating program...\n");
        freeWords(words, numWords);
        return -1;
    }
    bool* usedWord = (bool*)malloc(numWords * sizeof(bool));
    if (usedWord == NULL) {
        fprintf(stderr, "Memory allocation failed for usedWord array.\n");
        freeWords(words, numWords);
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < numWords; ++i) {
        usedWord[i] = false;
    }
    printf("Building array of %d-letter words... ", wordSize);
    bool status = buildWordArray(dict, words, numWords, wordSize);
    if (!status) {
        printf("  ERROR in building word array.\n");
        printf("  File not found or incorrect number of %d-letter words.\n", wordSize);
        printf("Terminating program...\n");
        free(words);
        free(usedWord);
        return -1;
    }
    printf("Done!\n");
    char startWord[30];
    char finalWord[30];
    printf("Setting the start %d-letter word... \n", wordSize);
    setWord(words, numWords, wordSize, startWord);
    printf("\n");
    printf("Setting the final %d-letter word... \n", wordSize);
    setWord(words, numWords, wordSize, finalWord);
    while (strcmp(finalWord, startWord) == 0) {
        printf("  The final word cannot be the same as the start word (%s).\n", startWord);
        printf("Setting the final %d-letter word... \n", wordSize);
        setWord(words, numWords, wordSize, finalWord);
    }
    printf("\n");
    WordNode* myLadder = findShortestWordLadder(words, usedWord, numWords, wordSize, startWord, finalWord);
    if (myLadder == NULL) {
        printf("There is no possible word ladder from %s to %s\n", startWord, finalWord);
    } else {
        printf("Shortest Word Ladder found!\n");
        printLadder(myLadder);
    }
    printf("Word Ladder height = %d\n", getLadderHeight(myLadder));
    freeLadder(myLadder);
    freeWords(words, numWords);
    free(usedWord);
    return 0;
}

