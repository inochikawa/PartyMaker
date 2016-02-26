// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PMRPartyManagedObject.h instead.

@import CoreData;

extern const struct PMRPartyManagedObjectAttributes {
	__unsafe_unretained NSString *creatorId;
	__unsafe_unretained NSString *endTime;
	__unsafe_unretained NSString *eventDescription;
	__unsafe_unretained NSString *eventId;
	__unsafe_unretained NSString *eventName;
	__unsafe_unretained NSString *imageIndex;
	__unsafe_unretained NSString *isPartyChanged;
	__unsafe_unretained NSString *isPartyDeleted;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *startTime;
} PMRPartyManagedObjectAttributes;

@interface PMRPartyManagedObjectID : NSManagedObjectID {}
@end

@interface _PMRPartyManagedObject : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PMRPartyManagedObjectID* objectID;

@property (nonatomic, strong) NSNumber* creatorId;

@property (atomic) int64_t creatorIdValue;
- (int64_t)creatorIdValue;
- (void)setCreatorIdValue:(int64_t)value_;

//- (BOOL)validateCreatorId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* endTime;

@property (atomic) int64_t endTimeValue;
- (int64_t)endTimeValue;
- (void)setEndTimeValue:(int64_t)value_;

//- (BOOL)validateEndTime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* eventDescription;

//- (BOOL)validateEventDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* eventId;

@property (atomic) int64_t eventIdValue;
- (int64_t)eventIdValue;
- (void)setEventIdValue:(int64_t)value_;

//- (BOOL)validateEventId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* eventName;

//- (BOOL)validateEventName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* imageIndex;

@property (atomic) int16_t imageIndexValue;
- (int16_t)imageIndexValue;
- (void)setImageIndexValue:(int16_t)value_;

//- (BOOL)validateImageIndex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isPartyChanged;

@property (atomic) BOOL isPartyChangedValue;
- (BOOL)isPartyChangedValue;
- (void)setIsPartyChangedValue:(BOOL)value_;

//- (BOOL)validateIsPartyChanged:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isPartyDeleted;

@property (atomic) BOOL isPartyDeletedValue;
- (BOOL)isPartyDeletedValue;
- (void)setIsPartyDeletedValue:(BOOL)value_;

//- (BOOL)validateIsPartyDeleted:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* latitude;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* longitude;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* startTime;

@property (atomic) int64_t startTimeValue;
- (int64_t)startTimeValue;
- (void)setStartTimeValue:(int64_t)value_;

//- (BOOL)validateStartTime:(id*)value_ error:(NSError**)error_;

@end

@interface _PMRPartyManagedObject (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveCreatorId;
- (void)setPrimitiveCreatorId:(NSNumber*)value;

- (int64_t)primitiveCreatorIdValue;
- (void)setPrimitiveCreatorIdValue:(int64_t)value_;

- (NSNumber*)primitiveEndTime;
- (void)setPrimitiveEndTime:(NSNumber*)value;

- (int64_t)primitiveEndTimeValue;
- (void)setPrimitiveEndTimeValue:(int64_t)value_;

- (NSString*)primitiveEventDescription;
- (void)setPrimitiveEventDescription:(NSString*)value;

- (NSNumber*)primitiveEventId;
- (void)setPrimitiveEventId:(NSNumber*)value;

- (int64_t)primitiveEventIdValue;
- (void)setPrimitiveEventIdValue:(int64_t)value_;

- (NSString*)primitiveEventName;
- (void)setPrimitiveEventName:(NSString*)value;

- (NSNumber*)primitiveImageIndex;
- (void)setPrimitiveImageIndex:(NSNumber*)value;

- (int16_t)primitiveImageIndexValue;
- (void)setPrimitiveImageIndexValue:(int16_t)value_;

- (NSNumber*)primitiveIsPartyChanged;
- (void)setPrimitiveIsPartyChanged:(NSNumber*)value;

- (BOOL)primitiveIsPartyChangedValue;
- (void)setPrimitiveIsPartyChangedValue:(BOOL)value_;

- (NSNumber*)primitiveIsPartyDeleted;
- (void)setPrimitiveIsPartyDeleted:(NSNumber*)value;

- (BOOL)primitiveIsPartyDeletedValue;
- (void)setPrimitiveIsPartyDeletedValue:(BOOL)value_;

- (NSString*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSString*)value;

- (NSString*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSString*)value;

- (NSNumber*)primitiveStartTime;
- (void)setPrimitiveStartTime:(NSNumber*)value;

- (int64_t)primitiveStartTimeValue;
- (void)setPrimitiveStartTimeValue:(int64_t)value_;

@end
