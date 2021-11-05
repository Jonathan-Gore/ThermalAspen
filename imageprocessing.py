#Python Functions to be Called into R
#Also the first time writing Python in about 1 1/2 years
#You got this

<<<<<<< Updated upstream
# custom_cpselect packages
import cv2
=======
import PIL


def print_function(string):
    return print(string)
>>>>>>> Stashed changes

def custom_cpselect(image_path):
    # function to display the coordinates of
    # of the points clicked on the image 
    def click_event(event, x, y, flags, params):
        # checking for left mouse clicks
        if event == cv2.EVENT_LBUTTONDOWN:
            # displaying the coordinates
            # on the Shell
            print(x, ' ', y)

            # displaying the coordinates
            # on the image window
            font = cv2.FONT_HERSHEY_SIMPLEX
            cv2.putText(img, str(x) + ',' +
                        str(y), (x,y), font,
                        1, (255, 0, 0), 2)
            cv2.imshow('image', img)

        # checking for right mouse clicks     
        if event==cv2.EVENT_RBUTTONDOWN:

            # displaying the coordinates
            # on the Shell
            print(x, ' ', y)

            # displaying the coordinates
            # on the image window
            font = cv2.FONT_HERSHEY_SIMPLEX
            b = img[y, x, 0]
            g = img[y, x, 1]
            r = img[y, x, 2]
            cv2.putText(img, str(b) + ',' +
                        str(g) + ',' + str(r),
                        (x,y), font, 1,
                        (255, 255, 0), 2)
            cv2.imshow('image', img)

    # driver function
    # previously indented out 1
    #if __name__=="__main__":

    # reading the image
    #img = cv2.imread('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/DC_60904.jpg', 1)
    img = cv2.imread(image_path, 1)

        # displaying the image
    cv2.imshow('image', img)

    # setting mouse hadler for the image
    # and calling the click_event() function
    cv2.setMouseCallback('image', click_event)
    
    # wait for a key to be pressed to exit
    cv2.waitKey(0)

    # close the window
    cv2.destroyAllWindows()

# test call of the custom_cpselect function
#custom_cpselect('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/IR_60901_scaled.jpg')
custom_cpselect('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/cropped.jpg')