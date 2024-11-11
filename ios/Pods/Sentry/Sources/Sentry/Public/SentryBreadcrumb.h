#import <Foundation/Foundation.h>

#if __has_include(<Sentry/Sentry.h>)
#    import <Sentry/SentryDefines.h>
#    import <Sentry/SentrySerializable.h>
#else
#    import <SentryWithoutUIKit/SentryDefines.h>
#    import <SentryWithoutUIKit/SentrySerializable.h>
#endif

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Breadcrumb)
@interface SentryBreadcrumb : NSObject <SentrySerializable>

/**
 * Level of breadcrumb
 */
@property (nonatomic) SentryLevel level;

/**
 * Category of bookmark, can be any string
 */
@property (nonatomic, copy) NSString *category;

/**
 * @c NSDate when the breadcrumb happened
 */
@property (nonatomic, strong, nullable) NSDate *timestamp;

/**
 * Type of breadcrumb, can be e.g.: http, empty, user, navigation
 * This will be used as icon of the breadcrumb
 */
@property (nonatomic, copy, nullable) NSString *type;

/**
 * Message for the breadcrumb
 */
@property (nonatomic, copy, nullable) NSString *message;

/**
 * Arbitrary additional data that will be sent with the breadcrumb
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *data;

/**
 * Initializer for @c SentryBreadcrumb
 * @param level SentryLevel
 * @param category String
 */
- (instancetype)initWithLevel:(SentryLevel)level category:(NSString *)category;
- (instancetype)init;
+ (instancetype)new NS_UNAVAILABLE;

- (NSDictionary<NSString *, id> *)serialize;

- (BOOL)isEqual:(id _Nullable)other;

- (BOOL)isEqualToBreadcrumb:(SentryBreadcrumb *)breadcrumb;

- (NSUInteger)hash;

@end

NS_ASSUME_NONNULL_END