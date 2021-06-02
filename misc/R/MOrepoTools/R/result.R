
#' Create a result file
#'
#' Create a result file named \code{<instanceName>_result_<other>.json} in json format.
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
#' @param print Also print the file (good for checking).
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' pts <- data.frame(z1 = c(27, 30, 31, 34, 42, 43, 49, 51), z2 = c(56, 53, 36, 33, 30, 25, 23, 9),
#'    type = c('se', 'us', 'se', 'us', 'us', 'us', 'us', 'se'))
#' createResultFile(instanceName = "Tuyttens00_AP_n05", contributionName = "Pedersen08",
#'    objectives = 2, points = pts, card = nrow(pts), suppCard = 3, extCard = 3,
#'    objectiveType = c("int", "int"), direction = c("min", "min"),
#'    comments = "Results from the paper by Pedersen et. al (2008)", optimal = TRUE,
#' )
#' createResultFile(instanceName = "Tuyttens00_AP_n05", contributionName = "Pedersen08",
#'    objectives = 2, points = pts, card = nrow(pts), suppCard = 3, extCard = 3,
#'    objectiveType = c("int", "int"), direction = c("min", "min"),
#'    comments = "Adding a misc list", optimal = TRUE,
#'    misc = list(a = 23, b = "text", c = 3.8, d = list(f = "sublist", g = 6), h = c(1,2,3)),
#'    print = TRUE
#' )
createResultFile<-function(instanceName, contributionName, objectives, points, card, suppCard = NULL,
   extCard = NULL, objectiveType = rep("int", objectives), direction = rep("min", objectives),
   comments = NULL, optimal = TRUE, cpu = NULL, valid = TRUE, version = "1.0", other = "", misc = NULL,
   print = FALSE)
{
   lst <- list()
   lst$version <- version
   lst$contributionName <- contributionName
   lst$instanceName <- instanceName
   lst$objectives <- objectives
   if (length(objectiveType)!=objectives) stop("Error: Length of objectiveType must be ", objectives)
   lst$objectiveType <- objectiveType
   if (!is.null(comments)) lst$comments <- comments
   if (length(direction)!=objectives) stop("Error: Length of direction must be ", objectives)
   lst$direction <- direction
   lst$optimal <- optimal
   if (!is.null(cpu)) lst$cpu <- list(sec = as.numeric(cpu[1]), machineSpec = cpu[2])
   lst$valid <- valid
   if (card != length(points$z1)) stop("Error: card is not equal the number of points!")
   lst$card <- card
   if (!is.null(suppCard)) lst$suppCard <- suppCard
   if (!is.null(extCard)) lst$extCard <- extCard
   lst$points <- points
   if (!is.null(misc)) lst$misc <- misc
   str<-jsonlite::toJSON(lst, auto_unbox = TRUE, pretty = TRUE, digits = NA, na = "null")
   if (other!="") other <- paste0("_", other)
   if (print) cat(str,"\n")
   fileN <- paste0(instanceName, "_result_", other, ".json")
   readr::write_lines(str, fileN)
   message("Results written to ", paste0(instanceName, "_result_", other, ".json"))
   message("Validate the file against schema ... ", appendLF = F)
   checkResult(fileN)
   message("ok.")
}




#' Modify the content of a result file
#'
#' Assume that you work with a local repository. All parameters not \code{NULL} are modified.
#'
#' @param fileN File name including path.
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
#' @param points A data frame with the nondominated points. Column names must be \code{z1, z2, ..., zn,
#'   type} where column \code{zi} is the value of the i'th objective and column type contains
#'   strings which may be either \code{us} (unsupported), \code{se} (supported extreme), \code{s}
#'   (supported - may be extreme or nonextreme), \code{sne} (supported nonextreme), \code{NA}
#'   (unknown).
#' @param check If \code{TRUE} validate the file against the schema.
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
#' modifyResultFile("Tuyttens00_AP_n05_result.json", comments = "New changed comment")
modifyResultFile<-function(fileN, instanceName = NULL, contributionName = NULL, objectives = NULL,
   points = NULL, card = NULL, suppCard = NULL, extCard = NULL, objectiveType = NULL,
   direction = NULL, comments = NULL, optimal = TRUE, cpu = NULL, valid = NULL, version = NULL,
   misc = NULL, check = TRUE)
{
   lst <- jsonlite::fromJSON(fileN)
   if (!is.null(version)) lst$version <- version
   if (!is.null(comments)) lst$comments <- comments
   if (!is.null(contributionName)) lst$contributionName <- contributionName
   if (!is.null(instanceName)) lst$instanceName <- instanceName
   if (!is.null(objectives)) lst$objectives <- objectives
   if (!is.null(objectiveType)) {
      if (length(objectiveType)!=lst$objectives) stop("Error: Length of objectiveType must be ", lst$objectives)
      lst$objectiveType <- objectiveType
   }
   if (!is.null(direction)) {
      if (length(direction)!=lst$objectives) stop("Error: Length of direction must be ", lst$objectives)
      lst$direction <- direction
   }
   if (!is.null(optimal)) lst$optimal <- optimal
   if (!is.null(suppCard)) lst$suppCard <- suppCard
   if (!is.null(extCard)) lst$extCard <- extCard
   if (!is.null(card)) lst$card <- card
   if (!is.null(points)) lst$points <- points
   if (lst$objectives != dim(lst$points)[2]-1) stop("Error: Number of objectives don't match columns in points!")
   if (lst$card != length(lst$points$z1)) stop("Error: card is not equal the number of points!")
   if (!is.null(cpu)) lst$cpu <- list(cpu = cpu[1], machineSpec = cpu[2])
   if (!is.null(misc)) lst$misc <- misc
   if (!is.null(valid)) lst$valid <- valid
   str<-jsonlite::toJSON(lst, auto_unbox = TRUE, pretty = TRUE, digits = NA, na = "null")
   readr::write_lines(str, fileN)
   message("Modified ", fileN)
   if (check) {
      message("Validate the file against schema ... ", appendLF = F)
      checkResult(fileN)
      message("ok.")
   }
}




#' Validate a result file based on schema.
#'
#' @param file Name of result file (with path).
#'
#' @return Warnings and errors (if any).
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' \dontrun{
#' checkResult("Tuyttens00_AP_n05_result.json")
#' }
checkResult<-function(file) {
   schema<-system.file("resultSchema.json", package = "MOrepoTools")
   jsonvalidate::json_validate(file, schema, verbose = TRUE, error = TRUE)
}



#' Plot the nondominated set (two objectives) in criterion space.
#'
#' @param file Relative file path within the contribution (or just file path if local file).
#' @param local Use local file (otherwise use the file at GitHub).
#' @param contribution Name of contribution (if use files at GitHub).
#' @param labels A vector of labels to be added.
#' @param addTriangles Add triangles to the non-dominated points.
#' @param latex If true make latex math labels for TikZ.
#' @param addHull Add the convex hull of the non-dominated points and rays.
#'
#' @return A ggplot object.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @import ggplot2
#' @example inst/examples/examples.R
plotNDSet<-function(file, contribution = NULL, local = FALSE, labels = NULL,
                    addTriangles = FALSE, latex = FALSE, addHull = FALSE) {
   if (!local) {
      if (is.null(contribution)) stop("Argument contribution must be specified!")
      path <- getFilePath(file, contribution)
   } else path <- file
   dat<-jsonlite::fromJSON(path)
   if (dat$objectives != 2) stop("Only two objectives supported!")
   points <- dat$points
   crit <- dat$direction[1]

   myTheme <- theme_set(theme_bw())
   myTheme <- theme_update(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                           panel.border = element_blank(),
                           #axis.line = element_blank(),
                           axis.line = element_line(colour = "black", size = 0.5, arrow = arrow(length = unit(0.3,"cm")) ),
                           #axis.ticks = element_blank()
                           #axis.text.x = element_text(margin = margin(r = 30))
                           # axis.ticks.length = unit(0.5,"mm"),
                           legend.position="none"
   )

   # Create criterion plot
   p <- ggplot(points, aes_string(x = 'z1', y = 'z2') )
   if (latex) p <- p + xlab("$z_1$") + ylab("$z_2$")
   if (!latex) p <- p + xlab(expression(z[1])) + ylab(expression(z[2]))
   p <- p + ggtitle(basename(path), subtitle = NULL)
   #coord_cartesian(xlim = c(min(points$z1)-delta, max(points$z1)+delta), ylim = c(min(points$z2)-delta, max(points$z2)+delta), expand = F) +
   if (addHull) {
      if (length(unique(dat$direction))>1) stop("addHull don't support combined min and max objectives!")
      tmp<-points[points$type == "se" & !duplicated(cbind(points$z1,points$z2), MARGIN = 1),]
      delta=max( (max(points$z1)-min(points$z1))/10, (max(points$z2)-min(points$z2))/10 )
      if (crit=="max") {
         tmp<-rbind(tmp[1:2,],tmp,tmp[1,]) # add rows
         tmp$z1[1] <- min(points$z1) - delta
         tmp$z2[1] <- min(points$z2) - delta
         tmp$z1[2] <- min(points$z1) - delta
         tmp$z2[2] <- max(points$z2)
         tmp$z1[length(tmp$z1)] <- max(points$z1)
         tmp$z2[length(tmp$z1)] <- min(points$z2)- delta
      }
      if (crit=="min") {
         tmp<-rbind(tmp[1,],tmp,tmp[1:2,]) # add rows
         tmp$z1[length(tmp$z1)-1] <- max(points$z1) + delta
         tmp$z2[length(tmp$z1)-1] <- min(points$z2)
         tmp$z1[1] <- min(points$z1)
         tmp$z2[1] <- max(points$z2) + delta
         tmp$z1[length(tmp$z1)] <- max(points$z1) + delta
         tmp$z2[length(tmp$z1)] <- max(points$z2) + delta
      }
      p <- p + geom_polygon(fill="gray90", data=tmp)
   }
   if (addTriangles) {
      tmp<-points[points$type == "se" | points$type == "sne" | points$type == "s",]
      if (length(tmp$z1)>1) { # triangles
         for (r in 1:(dim(tmp)[1] - 1)) {
            if (crit=="max") {
               p <- p +
                  geom_segment(x=tmp$z1[r],y=tmp$z2[r],xend=tmp$z1[r+1],yend=tmp$z2[r+1], colour="gray50") +
                  geom_segment(x=tmp$z1[r],y=tmp$z2[r],xend=tmp$z1[r],yend=tmp$z2[r+1], colour="gray50") +
                  geom_segment(x=tmp$z1[r],y=tmp$z2[r+1],xend=tmp$z1[r+1],yend=tmp$z2[r+1], colour="gray0")
            }
            if (crit=="min") {
               p <- p +
                  geom_segment(x=tmp$z1[r],y=tmp$z2[r],xend=tmp$z1[r+1],yend=tmp$z2[r+1], colour="gray50") +
                  geom_segment(x=tmp$z1[r],y=tmp$z2[r],xend=tmp$z1[r+1],yend=tmp$z2[r], colour="gray50") +
                  geom_segment(x=tmp$z1[r+1],y=tmp$z2[r],xend=tmp$z1[r+1],yend=tmp$z2[r+1], colour="gray0")
            }
         }
      }
   }

   p <- p + geom_point(aes_string(shape = 'type'), size = 1) +
      coord_fixed(ratio = 1) +
      scale_colour_grey(start = 0.6, end = 0)
   if (!is.null(labels)) {
      if (length(labels) != length(points$z1)) stop("The length of labels must be equal to the number of points!")
      points$lbl <- labels
      nudgeC=-(max(points$z1)-min(points$z1))/100
      p <- p + geom_text(data = points, aes_string(label = 'lbl'), nudge_x = nudgeC, nudge_y = nudgeC, hjust=1, size=3,
                            colour = "gray50")
   }
   return(p)
}






