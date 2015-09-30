//
//  MergeSortVC.m
//  Multithreaded-Merge-Sort
//
//  Created by Allan Luk on 2015-09-29.
//  Copyright (c) 2015 Allan Luk. All rights reserved.
//

#import "SortVC.h"

#define THREAD_START 0
#define THREAD_FINISHED 1
#define ARRAY_SIZE 100000

@interface SortVC ()

@end

@implementation SortVC {
    NSMutableArray *unsortedArray;
    NSConditionLock *threadLock;
}

- (void)loadView {
    
    [super loadView];
    self.title = @"Sort Time Comparisons";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initMergeSort];
}

- (void)initMergeSort {
    [self initMergeSortArrays];
    NSMutableArray *sortedArray = [NSMutableArray new];
    NSDate *startTime = [NSDate date];
    sortedArray = [self mergeSort:unsortedArray];
    NSLog(@"Merge Sort of %d Elements = %f seconds", ARRAY_SIZE,[[NSDate date] timeIntervalSinceDate:startTime]);
}

- (void)initMergeSortArrays {
    
    // Initialize Arrays
    unsortedArray = [NSMutableArray new];
    
    // Make array of 100 elements with values between 0-999
    for(int i = 0; i < ARRAY_SIZE; i++) {
        [unsortedArray addObject:[NSNumber numberWithInt:arc4random_uniform(1000)]];
    }
}

- (NSMutableArray*)mergeSort:(NSMutableArray*)array{
    
    NSMutableArray *leftArray = [NSMutableArray new];
    NSMutableArray *rightArray = [NSMutableArray new];
    
    if([array count] <= 1) {
        return array;
    } else {
        // Set midpoint
        int mid = (int)[array count]/2;
        
        // Add left-half to leftArray
        for(int i = 0; i < mid; i++) {
            [leftArray addObject:array[i]];
        }
    
        // Add right-half to rightArray
        for(int j = mid; j < [array count]; j++) {
            [rightArray addObject:array[j]];
        }
    
        // Put both sides of the array back into merge sort
        leftArray = [self mergeSort:leftArray];
        rightArray = [self mergeSort:rightArray];
        
        // If the last object in leftArray <= than the first object in rightArray, append + return
        if([leftArray lastObject] <= [rightArray firstObject]) {
            [leftArray addObjectsFromArray:rightArray];
            return leftArray;
        }
        
        // Return the result of merging the leftArray and rightArray together
        return [self merge:leftArray andRight:rightArray];
    }
}

- (NSMutableArray*)merge:(NSMutableArray*)leftArray andRight:(NSMutableArray*)rightArray {
    NSMutableArray *resultArray = [NSMutableArray new];
    
    // While there are still values in both arrays
    while([leftArray count] > 0 && [rightArray count] > 0) {
        // If the first element of leftArray is smaller, pop it to the resultArray
        if([leftArray firstObject] <= [rightArray firstObject]) {
            [resultArray addObject:[leftArray firstObject]];
            [leftArray removeObjectAtIndex:0];
        // If the first element of rightArray is smaller, pop it to the resultArray
        } else {
            [resultArray addObject:[rightArray firstObject]];
            [rightArray removeObjectAtIndex:0];
        }
    }
    
    // If leftArray still has elements, pop it to resultArray
    if([leftArray count] > 0) {
        [resultArray addObjectsFromArray:leftArray];
    }
    
    // If rightArray still has elements, pop it to resultArray
    if([rightArray count] > 0) {
        [resultArray addObjectsFromArray:rightArray];
    }
    
    return resultArray;
}

@end
