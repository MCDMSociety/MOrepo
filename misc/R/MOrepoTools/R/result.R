
#' Create a result file
#'
#' Create a result file named \code{<instanceName>_<other>_result.json} in json format.
#'
#' @param version Result format version (string). Currently version must be set to 1.0.
#' @param instanceName Name of instance not including the file extension (string).
#' @param contributionName The name of the the contribution (string).
#' @param objectives Number of objectives (number).
#' @param objectiveType Vector with strings \code{int}, \code{float} or \code{NA} (unknown) giving
#'   the numeric types of the objectives. Must have the same length as the number of objectives.
#' @param direction Vector with strings \code{min} or \code{max} giving the direction of the
#'   objectives.
#' @param comments Misc comments about the results (string).
#' @param optimal \code{TRUE} if an exact optimal solution, \code{FALSE} is know an approximation,
#'   \code{NA} if unknown, i.e. may be optimal (boolean, null).
#' @param suppCard Number of supported nondominated points (number). This is with respect to the
#'   solution found.
#' @param extCard Number of extreme supported nondominated points.
#' @param card Number of points.
#' @param cpu If not NULL, a vector with two entries cpu time in seconds (number) and machine
#'   specification (string).
#' @param valid If TRUE the results are considered valid. If FALSE the results may be in conflict
#'   with results on the same instance from other contributions.
#' @param misc If not NULL, an entry you may use as you like (vector, list etc.). It could e.g.
#'   contain an object with more detailed entries about the experiment.
#' @param other String added to the result file name.
#' @param points A data frame with the nondominated points. Column names must be \code{z1, z2, ..., zn,
#'   type} where column \code{zi} is the value of the i'th objective and column type contains
#'   strings which may be either \code{us} (unsupported), \code{se} (supported extreme), \code{s}
#'   (supported - may be extreme or nonextreme), \code{sne} (supported nonextreme), \code{NA}
#'   (unknown).
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' points <- data.frame(z1 = c(27, 30, 31, 34, 42, 43, 49, 51), z2 = c(56, 53, 36, 33, 30, 25, 23, 9),
#'    type = c('se', 'us', 'se', 'us', 'us', 'us', 'us', 'se'))
#' createResultFile(instanceName = "Tuyttens00_AP_n05", contributionName = "Pedersen08",
#'    objectives = 2, points = points, card = 8, suppCard = 3, extCard = 3,
#'    objectiveType = c("int", "int"), direction = c("min", "min"),
#'    comments = "Results from the paper by Pedersen et. al (2008)", optimal = TRUE
#' )
createResultFile<-function(instanceName, contributionName, objectives, points, card, suppCard = NULL,
   extCard = NULL, objectiveType = rep("int", objectives), direction = rep("min", objectives),
   comments = NULL, optimal = TRUE, cpu = NULL, valid = TRUE, version = "1.0", other = "", misc = NULL)
{
   lst <- list()
   lst$version <- version
   if (!is.null(comments)) lst$comments <- comments
   lst$contributionName <- contributionName
   lst$instanceName <- instanceName
   lst$objectives <- objectives
   if (length(objectiveType)!=objectives) stop("Error: Length of objectiveType must be ", objectives)
   lst$objectiveType <- objectiveType
   if (length(direction)!=objectives) stop("Error: Length of direction must be ", objectives)
   lst$direction <- direction
   lst$optimal <- optimal
   if (!is.null(suppCard)) lst$suppCard <- suppCard
   if (!is.null(extCard)) lst$extCard <- extCard
   if (card != length(points$z1)) stop("Error: card is not equal the number of points!")
   lst$card <- card
   lst$points <- points
   if (!is.null(cpu)) lst$cpu <- list(cpu = cpu[1], machineSpec = cpu[2])
   if (!is.null(misc)) lst$misc <- misc
   lst$valid <- valid
   str<-jsonlite::toJSON(lst, auto_unbox = TRUE, pretty = TRUE, digits = NA)
   if (other!="") other <- paste0("_", other, "_")
   readr::write_lines(str, paste0(instanceName, other, "_result.json"))
   message("Results written to ", paste0(instanceName, other, "_result.json"))
}


#' Validate a result file based on schema.
#'
#' @param file Name of result file.
#'
#' @return Warnings and errors (if any).
#' @author Lars Relund \email{lars@@relund.dk}
#' @examples
#' MOrepoTools:::checkResult("Tuyttens00_AP_n05_result.json")
checkResult<-function(file) {
   schema<-system.file("resultSchema.json", package = "MOrepoTools")
   jsonvalidate::json_validate(file, schema, verbose = TRUE, error = TRUE)
}



