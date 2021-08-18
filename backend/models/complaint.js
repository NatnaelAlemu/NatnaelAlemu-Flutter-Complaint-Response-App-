import mongoose from 'mongoose'

const UserSchema = new mongoose.Schema({
    fullName:{
        type: String,
        required: true
    },
    email: {
        type:String,
        required:true
    },
    username:{
        type:String, 
        required:true
    },
    password: {
        type:String,
        required:true
    },
    role:{
        type:String,
        required:true
    }
})

export default mongoose.model('User',UserSchema)