require 'spec_helper'

describe "UserPages" do
subject{page}



  describe "index" do
	let(:user){FactoryGirl.create(:user)}
	let(:admin) { FactoryGirl.create(:admin) }

 	before {
		sign_in admin
		visit users_path
	}
	it {should have_title('All users')}
	it {should have_link("delete", href: user_path(user))}
        it { should_not have_link('delete', href: user_path(admin)) }
	it "should able to delete other user" do
		expect{click_link('delete', match: :first)}.to change(User, :count).by(-1)
	end

  end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin}

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

  describe "sign up" do
  	before {visit signup_path}
	it {should have_content('Sign up')}
	it {should have_title(full_title('Sign up'))}
  end

describe "profile page" do
  # Replace with code to make a user variable
let(:user) { FactoryGirl.create(:user) }    
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
before { visit user_path(user) }
  
       it { should have_content(user.name) }
         it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

         end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_link('Profile',     href: user_path(user)) }
	it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end

    
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { 
	sign_in user
	visit edit_user_path(user) 
    }

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "valid edit" do
	let(:new_name){"New Name"}
	let(:new_email){"email2@mail.com"}
	
	before do
		fill_in "Name",	with: new_name
		fill_in "Email", with: new_email
		fill_in "Password", with: user.password
		fill_in "Confirm Password", with: user.password
		click_button "Save changes"
	end

	it {should have_title(new_name)}
	it {should have_selector('div.alert.alert-success') }
	it {should have_link("Sign out", href: signout_path)}
        specify { expect(user.reload.name).to  eq new_name }
        specify { expect(user.reload.email).to eq new_email }
    end
  end
end

