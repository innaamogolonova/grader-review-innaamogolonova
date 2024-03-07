CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

# deletes previous student and grading dirs
rm -rf student-submission
rm -rf grading-area

# makes the grading dir again
mkdir grading-area

# git clones the student repo
git clone $1 student-submission 2> git-output.txt

# checks if the file exists in the student repo
if [ -f "student-submission/ListExamples.java" ]; then 
    # moves the appropriate files to grading dir 
    cp student-submission/ListExamples.java grading-area
    cp -r lib grading-area
    cp TestListExamples.java grading-area
else 
    echo "ListExamples.java not found"
    exit 1
fi

# compiles the files in grading dir 
cd grading-area 
javac -cp $CPATH *.java

# checks if there is a compile error 
if [ $? -ne 0 ]; then 
    echo "Compile error, please address the issue above"
    exit 1
fi 

# runs the JUnit tests of ListExamples.java
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > output.txt

# displays how many tests passed and failed in the terminal

test_result=$(tail -2 output.txt | head -1)

message=$(echo $test_result | awk '{print $1}')

if [ $message == "OK" ]; then 
    echo "All tests passed"
else
    total_tests=$(echo $test_result | grep -oE '[0-9]+' | head -1)
    failures=$(echo $test_result | grep -oE '[0-9]+' | tail -1)

    passed=$((total_tests - failures))
    cat output.txt
    echo "Tests passed: $passed out of $total_tests total. Adress the issues above" 
fi
