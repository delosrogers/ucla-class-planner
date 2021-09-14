use anyhow::Error;
use scraper::{Html, Selector};

pub fn scrape_dars(dars_string: &str) -> Result<Vec<CourseNameNum>, Error> {
    let doc = Html::parse_document(dars_string);
    // we are ignoring all completed requirements I think that this is ok
    let req_nodes_selector =
        Selector::parse("#auditRequirements .requirement.Status_NO .course.draggable").unwrap();
    let req_nodes = doc.select(&req_nodes_selector);
    // eprintln!("{:?}", req_nodes);
    let courses_required: Vec<CourseNameNum> = req_nodes
        .map(|el_ref| {
            el_ref.value().attr("department").and_then(|dept| {
                el_ref.value().attr("number").and_then(|num| {
                    let dept_owned = dept.trim().to_owned();
                    let num_owned = num.trim().to_owned();
                    return Some(CourseNameNum {
                        dept: dept_owned,
                        number: num_owned,
                    });
                })
            })
        })
        .filter(|maybe_course| maybe_course.is_some())
        // won't panic becuase we just filtered out the none variants
        .map(|course| course.unwrap())
        .collect();
    return Ok(courses_required);
}

#[derive(Debug)]
pub struct CourseNameNum {
    pub(crate) dept: String,
    pub(crate) number: String,
}

pub struct CourseWithPrereqs {
    pub(crate) course: CourseNameNum,
    pub(crate) prereqs: Vec<CourseNameNum>,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parsing_basic() {
        let dars_bytes = include_bytes!("/home/mattias/Documents/NSO docs/dar-sep-13.html");
        let dars_string = String::from_utf8_lossy(dars_bytes).into_owned();
        let courses = scrape_dars(dars_string.as_str());
        eprintln!("{:?}", courses);
        assert!(false);
    }
}
