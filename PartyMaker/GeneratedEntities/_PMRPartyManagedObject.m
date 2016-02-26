// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PMRPartyManagedObject.m instead.

#import "_PMRPartyManagedObject.h"

const struct PMRPartyManagedObjectAttributes PMRPartyManagedObjectAttributes = {
	.creatorId = @"creatorId",
	.endTime = @"endTime",
	.eventDescription = @"eventDescription",
	.eventId = @"eventId",
	.eventName = @"eventName",
	.imageIndex = @"imageIndex",
	.isPartyChanged = @"isPartyChanged",
	.isPartyDeleted = @"isPartyDeleted",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.startTime = @"startTime",
};

@implementation PMRPartyManagedObjectID
@end

@implementation _PMRPartyManagedObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Party" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Party";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Party" inManagedObjectContext:moc_];
}

- (PMRPartyManagedObjectID*)objectID {
	return (PMRPartyManagedObjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"creatorIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"creatorId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"endTimeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"endTime"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"eventIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"eventId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"imageIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"imageIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isPartyChangedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isPartyChanged"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isPartyDeletedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isPartyDeleted"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"startTimeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"startTime"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic creatorId;

- (int64_t)creatorIdValue {
	NSNumber *result = [self creatorId];
	return [result longLongValue];
}

- (void)setCreatorIdValue:(int64_t)value_ {
	[self setCreatorId:@(value_)];
}

- (int64_t)primitiveCreatorIdValue {
	NSNumber *result = [self primitiveCreatorId];
	return [result longLongValue];
}

- (void)setPrimitiveCreatorIdValue:(int64_t)value_ {
	[self setPrimitiveCreatorId:@(value_)];
}

@dynamic endTime;

- (int64_t)endTimeValue {
	NSNumber *result = [self endTime];
	return [result longLongValue];
}

- (void)setEndTimeValue:(int64_t)value_ {
	[self setEndTime:@(value_)];
}

- (int64_t)primitiveEndTimeValue {
	NSNumber *result = [self primitiveEndTime];
	return [result longLongValue];
}

- (void)setPrimitiveEndTimeValue:(int64_t)value_ {
	[self setPrimitiveEndTime:@(value_)];
}

@dynamic eventDescription;

@dynamic eventId;

- (int64_t)eventIdValue {
	NSNumber *result = [self eventId];
	return [result longLongValue];
}

- (void)setEventIdValue:(int64_t)value_ {
	[self setEventId:@(value_)];
}

- (int64_t)primitiveEventIdValue {
	NSNumber *result = [self primitiveEventId];
	return [result longLongValue];
}

- (void)setPrimitiveEventIdValue:(int64_t)value_ {
	[self setPrimitiveEventId:@(value_)];
}

@dynamic eventName;

@dynamic imageIndex;

- (int16_t)imageIndexValue {
	NSNumber *result = [self imageIndex];
	return [result shortValue];
}

- (void)setImageIndexValue:(int16_t)value_ {
	[self setImageIndex:@(value_)];
}

- (int16_t)primitiveImageIndexValue {
	NSNumber *result = [self primitiveImageIndex];
	return [result shortValue];
}

- (void)setPrimitiveImageIndexValue:(int16_t)value_ {
	[self setPrimitiveImageIndex:@(value_)];
}

@dynamic isPartyChanged;

- (BOOL)isPartyChangedValue {
	NSNumber *result = [self isPartyChanged];
	return [result boolValue];
}

- (void)setIsPartyChangedValue:(BOOL)value_ {
	[self setIsPartyChanged:@(value_)];
}

- (BOOL)primitiveIsPartyChangedValue {
	NSNumber *result = [self primitiveIsPartyChanged];
	return [result boolValue];
}

- (void)setPrimitiveIsPartyChangedValue:(BOOL)value_ {
	[self setPrimitiveIsPartyChanged:@(value_)];
}

@dynamic isPartyDeleted;

- (BOOL)isPartyDeletedValue {
	NSNumber *result = [self isPartyDeleted];
	return [result boolValue];
}

- (void)setIsPartyDeletedValue:(BOOL)value_ {
	[self setIsPartyDeleted:@(value_)];
}

- (BOOL)primitiveIsPartyDeletedValue {
	NSNumber *result = [self primitiveIsPartyDeleted];
	return [result boolValue];
}

- (void)setPrimitiveIsPartyDeletedValue:(BOOL)value_ {
	[self setPrimitiveIsPartyDeleted:@(value_)];
}

@dynamic latitude;

@dynamic longitude;

@dynamic startTime;

- (int64_t)startTimeValue {
	NSNumber *result = [self startTime];
	return [result longLongValue];
}

- (void)setStartTimeValue:(int64_t)value_ {
	[self setStartTime:@(value_)];
}

- (int64_t)primitiveStartTimeValue {
	NSNumber *result = [self primitiveStartTime];
	return [result longLongValue];
}

- (void)setPrimitiveStartTimeValue:(int64_t)value_ {
	[self setPrimitiveStartTime:@(value_)];
}

@end

