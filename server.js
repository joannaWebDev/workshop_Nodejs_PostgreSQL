/* =====================================================================================
READY.GO!                           
====================================================================================*/
'use strict';
const express = require("express");
const app = express();

const cloudinary = require('cloudinary').v2;
const db = require('./dbConnect.js');

const bodyParser = require('body-parser');
const {
  Pool
} = require("pg");
const secrets = require('./secrets.json');
/* =====================================================================================
body parser configuration                        
====================================================================================*/
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
  extended: true
}));
/* =====================================================================================
cloudinary configuration                         
====================================================================================*/
cloudinary.config({
  cloud_name: secrets.cloud_name,
  api_key: secrets.api_key,
  api_secret: secrets.api_secret
});
/* =====================================================================================
To avoid bug in our code, First replace the existing API with the following code:                       
====================================================================================*/
app.get("/", (request, response) => {
  response.json({
    message: "Hey! This is your server response!"
  });
});

/* =====================================================================================

====================================================================================*/
app.use(express.urlencoded({
  extended: true
}));
app.use(express.json());

const port = 3002;

const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "workshop",
  password: secrets.password,
  port: 5432,
  max: 10, // max number of clients in the pool
})

/* =====================================================================================
VARIABLES FOR THE GET ENDPOINTS 
====================================================================================*/
const getTopics = (req, res) => {
  pool
    .query('SELECT * FROM topics ORDER BY topic_name  ')
    .then(result => res.send(result.rows))
    .catch(error => {
      console.log(error);
      res.send('Oops.Try again please 😕')
    })
}

const getClasses = (req, res) => {
  pool
    .query('SELECT * FROM classes ORDER BY class_name ')
    .then(result => res.send(result.rows))
    .catch(error => {
      console.log(error);
      res.send('Oops.Try again please 😕')
    })
}

const getStudents = (req, res) => {
  pool
    .query('SELECT * FROM students  ORDER BY students_name ')
    .then(result => res.send(result.rows))
    .catch(error => {
      console.log(error);
      res.send('Oops.Try again please 😕')
    })
}


//img
const getStudentsImg = (req, res) => {
  const studentId = req.params.students_id;

  pool
    .query(`select i.image_url from students s
            join images i on i.id = s.avatar_id 
            where s.id = $1;`,[studentId])
    .then(result => {
      const imgUrl = result.rows[0].image_url;
      res.send(`
                <img src="${imgUrl}" alt=""/ >
                <p>This is the avatar</p>
                
      `)
    })
    .catch(error => {
      console.log(error);
      res.send('Oops.Try again please 😕')
    })
}


const getStudentsAndClasses = (req, res) => {
  pool
    .query('SELECT * FROM students_classes ORDER BY class_id ')
    .then(result => res.send(result.rows))
    .catch(error => {
      console.log(error);
      res.send('Oops.Try again please 😕')
    })
}

/* =====================================================================================
VARIABLES FOR THE POST ENDPOINTS 
====================================================================================*/
const postStudent = (req, res) => {
  const studentName = req.body.students_name ;
  const topicId = req.body.volunteer_id;
  const startTime = req.body.avatar_id;

    const query = 'INSERT INTO students (students_name, volunteer_id, avatar_id)  VALUES ($1, $2, $3)';

    pool
    .query(query, [studentName, topicId, startTime])
    .then(() => res.send('Student created! 😉'))
    .catch(error => {
      console.log(error);
      res.send('Oops.We did it again. 😕')
    })
}

const postClass = (req, res) => {
  const className = req.body.class_name ;
  const topicId = req.body.topic_id;
  const startTime = req.body.start_time;
  const endTime = req.body.end_time ;

  const query = 'INSERT INTO classes (class_name, topic_id, start_time, end_time) VALUES ($1, $2, $3, $4)';

  pool
  .query(query, [className, topicId, startTime,endTime])
  .then(() => response.send("Class created! 😉"))
  .catch(error => {
    console.log(error);
    res.send('Oops.We did it again. 😕')
  })
}

const postTopic = (req, res) => {
  const topicName = req.body.topic_name ;
  const query = 'INSERT INTO topics (topic_name)  VALUES ($1)';

  pool
  .query(query, [topicName])
  .then(() => res.send('Topic created! 😉'))
  .catch(error => {
    console.log(error);
    res.send('Oops.We did it again. 😕')
  })
}


const postStudentIntoClass = (req, res) => {
  const studentId = req.body.student_id ;
  const classId = req.body.class_id ;
  const query = 'INSERT INTO students_classes (student_id, class_id)  VALUES ($1, $2)';

  pool
  .query(query, [studentId,classId])
  .then(() => res.send('Student assigned to class! 😉'))
  .catch(error => {
    console.log(error);
    res.send('Oops.We did it again. 😕')
  })
}

/* =====================================================================================
ENDPOINTS GET
====================================================================================*/
app.get('/topics', getTopics);
app.get('/classes', getClasses);
app.get('/students', getStudents);
app.get('/students_classes', getStudentsAndClasses);
app.get('/students-image/:students_id', getStudentsImg);
/* =====================================================================================
ENDPOINTS POST
====================================================================================*/
app.post("/students", postStudent);
app.post("/classes", postClass);
app.post("/topics", postTopic); 
app.post("/student-assigned-to-class", postStudentIntoClass);

/* =====================================================================================
UPLOAD IMAGES TO/FROM CLOUDINARY
====================================================================================*/
const imageUpload = (request, response) => {
  // collected image from a user
  const data = {
    image: request.body.image,
  };

  // upload image here
  cloudinary.uploader
    .upload(data.image)
    .then((result) => {
      response.status(200).send({
        message: "success",
        result,
      });
    })
    .catch((error) => {
      response.status(500).send({
        message: "failure",
        error,
      });
    });
};

const persistImage = (request, response) => {
  // collected image from a user
  const data = {
    title: request.body.title,
    image: request.body.image,
  };

  // upload image here
  cloudinary.uploader
    .upload(data.image)
    .then((image) => {
      db.pool.connect((err, client) => {
        // insert query to run if the upload to cloudinary is successful
        const insertQuery =
          "INSERT INTO images (title, cloudinary_id, image_url) VALUES($1,$2,$3) RETURNING *";
        const values = [data.title, image.public_id, image.secure_url];

        // execute query
        client
          .query(insertQuery, values)
          .then((result) => {
            result = result.rows[0];

            // send success response
            response.status(201).send({
              status: "success",
              data: {
                message: "Image Uploaded Successfully",
                title: result.title,
                cloudinary_id: result.cloudinary_id,
                image_url: result.image_url,
              },
            });
          })
          .catch((e) => {
            response.status(500).send({
              message: "failure",
              e,
            });
          });
      });
    })
    .catch((error) => {
      response.status(500).send({
        message: "failure",
        error,
      });
    });
}

const retrieveImage = (request, response) => {
  // data from user
  const {
    cloudinary_id
  } = request.params;

  db.pool.connect((err, client) => {
    // query to find image
    const retrieveQuery = "SELECT * FROM images WHERE cloudinary_id = $1";
    const value = [cloudinary_id];

    // execute query
    client
      .query(retrieveQuery, value)
      .then((output) => {
        response.status(200).send({
          status: "success",
          data: {
            message: "Image Retrieved Successfully!",
            id: output.rows[0].cloudinary_id,
            title: output.rows[0].title,
            url: output.rows[0].image_url,
          },
        });
      })
      .catch((error) => {
        response.status(401).send({
          status: "failure",
          data: {
            message: "could not retrieve record!",
            error,
          },
        });
      });
  });
}

const deleteImage = (request, response) => {
  // unique ID
  const {
    cloudinary_id
  } = request.params;

  // delete image from cloudinary first
  cloudinary.uploader
    .destroy(cloudinary_id)

    // delete image record from postgres also
    .then(() => {
      db.pool.connect((err, client) => {
        // delete query
        const deleteQuery = "DELETE FROM images WHERE cloudinary_id = $1";
        const deleteValue = [cloudinary_id];

        // execute delete query
        client
          .query(deleteQuery, deleteValue)
          .then((deleteResult) => {
            response.status(200).send({
              message: "Image Deleted Successfully!",
              deleteResult,
            });
          })
          .catch((e) => {
            response.status(500).send({
              message: "Image Couldn't be Deleted!",
              e,
            });
          });
      });
    })
    .catch((error) => {
      response.status(500).send({
        message: "Failure",
        error,
      });
    });
};


/*****ERROR*****/
const updateImage = (request, response) => {
  // unique ID
  const {
    cloudinary_id
  } = request.params;

  // collected image from a user
  const data = {
    title: request.body.title,
    image: request.body.image,
  };

  // delete image from cloudinary first
  cloudinary.uploader
    .destroy(cloudinary_id)

    // upload image here
    .then(() => {
      cloudinary.uploader
        .upload(data.image)

        // update the database here
        .then((result) => {
          db.pool.connect((err, client) => {
            // update query
            const updateQuery =
              "UPDATE images SET title = $1, cloudinary_id = $2, image_url = $3 WHERE cloudinary_id = $4";
            const value = [
              data.title,
              result.public_id,
              result.secure_url,
              cloudinary_id,
            ];

            // execute query
            client
              .query(updateQuery, value)
              .then(() => {
                // send success response
                response.status(201).send({
                  status: "success",
                  data: {
                    message: "Image Updated Successfully",
                  },
                });
              })
              .catch((e) => {
                response.status(500).send({
                  message: "Update Failed",
                  e,
                });
              });
          });
        })
        .catch((err) => {
          response.status(500).send({
            message: "failed",
            err,
          });
        });
    })
    .catch((error) => {
      response.status(500).send({
        message: "failed",
        error,
      });
    });
}

/* =====================================================================================
image upload API ENDPOINTS
====================================================================================*/
/* IMAGE UPLOAD
POSTMAN
In the address bar enter this: http://localhost:3000/image-upload
Set the Header Key to Content-Type and value to application/json
Set the body to the json data we declared in our code like so:
      {
      "image": "images/sample.jpg"
      } */
app.post("/image-upload", imageUpload);


// PERSIST IMAGE 
/*POSTMAN 
In the address bar enter this: http://localhost:3000/persist-image
Set the body to the json data we declared in our code like so:
      {
      "title": "An Image",
      "image": "images/avatar.jpg"
      }*/
app.post("/persist-image", persistImage);




// RETRIEVE IMAGE
/*POSTMAN 
In the address bar enter this:GET: http://localhost:3000/retrieve-image/krlhmmncubetwzbrc3or
Set the ***Header*** Key to Content-Type and value to application/json
***BODY***:none
*/
app.get("/retrieve-image/:cloudinary_id", retrieveImage);



// DELETE IMAGE FROM CLOUDINARY   "message": "Image Deleted Successfully!",
app.delete("/delete-image/:cloudinary_id", deleteImage);



// UPDATE IMAGE FROM CLOUDINARY  /*****ERROR**** BUT THE IMAGE DOES GET DELETED FROM CLOUDINARY*/
/*POSTMAN body:  {
      "title": "Updated Image",
      "id": "pweihantdtl5g7qmmvzu",
      "url": "https://res.cloudinary.com/cloudydays/image/upload/v1609955755/pweihantdtl5g7qmmvzu.png"
      }

 {
    "message": "failed",
    "err": {
        "message": "Missing required parameter - file",
        "name": "Error",
        "http_code": 400
    }
}*/     
app.put("/update-image/:cloudinary_id", updateImage);


app.listen(port, () => console.log(`Server is listening on port ${port}.`))