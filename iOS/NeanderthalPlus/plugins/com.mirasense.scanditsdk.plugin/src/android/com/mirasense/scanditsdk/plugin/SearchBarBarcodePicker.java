package com.mirasense.scanditsdk.plugin;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Rect;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.RelativeLayout;

import com.scandit.barcodepicker.BarcodePicker;
import com.scandit.barcodepicker.ScanSettings;
import com.scandit.barcodepicker.internal.gui.view.SearchBar;
import com.scandit.base.system.SbSystemUtils;

/**
 * Created by mo on 29/10/15.
 */
public class SearchBarBarcodePicker extends BarcodePicker {

    private ScanditSDKSearchBar mSearchBar;
    private ScanditSDKSearchBarListener mListener;

    public static Rect portraitMargins = new Rect(0, 0, 0, 0);
    public static Rect landscapeMargins = new Rect(0, 0, 0, 0);


    public SearchBarBarcodePicker(Context context) {
        super(context);
    }

    public SearchBarBarcodePicker(Context context, ScanSettings settings) {
        super(context, settings);
    }

    public void adjustSize(Activity activity, Rect newPortraitMargins,
                           Rect newLandscapeMargins, double animationDuration) {
        final RelativeLayout.LayoutParams rLayoutParams = (RelativeLayout.LayoutParams) getLayoutParams();

        Display display = activity.getWindowManager().getDefaultDisplay();
        int screenWidth = display.getWidth();
        int screenHeight = display.getHeight();

        final Rect oldMargins;
        final Rect newMargins;
        if (screenHeight > screenWidth) {
            oldMargins = portraitMargins;;
            newMargins = newPortraitMargins;
        } else {
            oldMargins = landscapeMargins;
            newMargins = newLandscapeMargins;
        }

        if (animationDuration > 0) {
            Animation anim = new Animation() {
                @Override
                protected void applyTransformation(float interpolatedTime, Transformation t) {
                    rLayoutParams.topMargin = SbSystemUtils.pxFromDp(getContext(),
                            (int) (oldMargins.top + (newMargins.top
                                    - oldMargins.top) * interpolatedTime));
                    rLayoutParams.rightMargin = SbSystemUtils.pxFromDp(getContext(),
                            (int) (oldMargins.right + (newMargins.right
                                    - oldMargins.right) * interpolatedTime));
                    rLayoutParams.bottomMargin = SbSystemUtils.pxFromDp(getContext(),
                            (int) (oldMargins.bottom + (newMargins.bottom
                                    - oldMargins.bottom) * interpolatedTime));
                    rLayoutParams.leftMargin = SbSystemUtils.pxFromDp(getContext(),
                            (int) (oldMargins.left + (newMargins.left
                                    - oldMargins.left) * interpolatedTime));
                    setLayoutParams(rLayoutParams);
                }
            };
            anim.setDuration((int) (animationDuration * 1000));
            startAnimation(anim);
        } else {
            rLayoutParams.topMargin = SbSystemUtils.pxFromDp(getContext(), newMargins.top);
            rLayoutParams.rightMargin = SbSystemUtils.pxFromDp(getContext(), newMargins.right);
            rLayoutParams.bottomMargin = SbSystemUtils.pxFromDp(getContext(), newMargins.bottom);
            rLayoutParams.leftMargin = SbSystemUtils.pxFromDp(getContext(), newMargins.left);
            setLayoutParams(rLayoutParams);
        }
        portraitMargins = newPortraitMargins;
        landscapeMargins = newLandscapeMargins;
    }

    public void setOnSearchBarListener(ScanditSDKSearchBarListener listener) {
        mListener = listener;
    }

    public void showSearchBar(boolean show) {
        if (show && mSearchBar == null) {
            mSearchBar = new ScanditSDKSearchBar(getContext(), new OnClickListener() {
                @Override
                public void onClick(View v) {
                    onSearchClicked();
                }
            });
            RelativeLayout.LayoutParams rParams = new RelativeLayout.LayoutParams(
                    LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
            rParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
            rParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
            addView(mSearchBar, rParams);
            
            getOverlayView().setTorchButtonMarginsAndSize(15, 55, 40, 40);
            getOverlayView().setCameraSwitchButtonMarginsAndSize(15, 55, 40, 40);
            
            requestChildFocus(null, null);
        } else if (!show && mSearchBar != null) {
            removeView(mSearchBar);
            mSearchBar = null;
            invalidate();
        }
    }

    protected void setSearchBarPlaceholderText(String text) {
        mSearchBar.setHint(text);
    }

    private void onSearchClicked() {
        mListener.didEnter(mSearchBar.getText());
    }


    public interface ScanditSDKSearchBarListener {
        /**
         *  Called whenever a string was entered in the search bar and the button to search was pressed.
         *
         *  @param entry the text that has been entered by the user.
         */
        void didEnter(String entry);
    }
}
