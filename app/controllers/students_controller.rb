class StudentsController < ApplicationController
    def index
        students = Student.all
        render json: students, status: :ok
    end
    
    def show
        student = Student.find_by(id: params[:id])
        if student
            render json: student, status: :ok
        else
            render json: { error: "Student Not Found" }, status: :not_found
        end
    end

    def create
        instructor = Instructor.find_by(id: params[:instructor_id])
        if instructor
            student = Student.create(name: params[:name], major: params[:major], age: params[:age], instructor_id: params[:instructor_id])
            if student.valid?
                render json: student, status: :created
            else
                render json: { errors: student.errors }, status: :unprocessable_entity
            end
        else
            render json: { error: "Invalid Instructor ID! Instructor Not Found!" }, status: :not_found
        end
    end

    def update
        student = Student.find_by(id: params[:id])
        if student
            if params[:instructor_id]
                instructor = Instructor.find_by(id: params[:instructor_id])
                if !instructor
                    return render json: { error: "Invalid Instructor ID! Instructor Not Found!" }, status: :not_found
                end
            end
            student.update(student_params)
            if student.valid?
                render json: student, status: :ok
            else
                render json: { errors: student.errors }, status: :unprocessable_entity
            end
        else
            render json: { error: "Student Not Found!" }, status: :not_found
        end
    end

    def destroy
        student = Student.find_by(id: params[:id])
        if student
            student.destroy
            render json: {}, status: :no_content
        else
            render json: { error: "Student Not Found!" }, status: :not_found
        end
    end

    private

    def student_params
        params.permit(:name, :major, :age, :instructor_id)
    end
end
