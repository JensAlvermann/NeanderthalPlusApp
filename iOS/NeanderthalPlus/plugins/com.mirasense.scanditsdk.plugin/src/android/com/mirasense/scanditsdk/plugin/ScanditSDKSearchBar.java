package com.mirasense.scanditsdk.plugin;

import android.annotation.SuppressLint;
import android.content.Context;
import android.text.Editable;
import android.text.InputType;
import android.text.TextUtils.TruncateAt;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.RelativeLayout;
import com.scandit.base.geometry.SbRectangle;
import com.scandit.base.system.SbResourceUtils;
import com.scandit.base.view.SbImageButton;

/**
 * Layout containing the search bar.
 * 
 * @author Moritz Hartmeier
 */
@SuppressLint("ViewConstructor")
public class ScanditSDKSearchBar extends RelativeLayout {

	private EditText mSearchEditText;
	private OnClickListener mOnClickListener = null;
	
	
	public ScanditSDKSearchBar(Context context) {
		this(context, null);
	}
	
	public ScanditSDKSearchBar(Context context, OnClickListener listener) {
		super(context);

		mOnClickListener = listener;
		
        RelativeLayout.LayoutParams rParams;
        
        mSearchEditText = new EditText(getContext());
        mSearchEditText.setLines(1);
        mSearchEditText.setEllipsize(TruncateAt.START);
        mSearchEditText.setInputType(InputType.TYPE_CLASS_NUMBER);
        mSearchEditText.setImeOptions(EditorInfo.IME_ACTION_SEARCH);
        rParams = new RelativeLayout.LayoutParams(
                LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
        rParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        addView(mSearchEditText, rParams);
        mSearchEditText.setOnKeyListener(new OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (event.getKeyCode() == KeyEvent.KEYCODE_ENTER
                            && event.getAction() == KeyEvent.ACTION_UP) {
                	onButtonClicked();
                    return true;
                }
                return false;
            }
        });
	}
	
	private void onButtonClicked() {
        InputMethodManager imm = 
            (InputMethodManager) getContext().getSystemService(
                    Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(
                mSearchEditText.getApplicationWindowToken(), 0);
        
        if (mOnClickListener != null) {
        	mOnClickListener.onClick(null);
        }
	}
	
	public void setHint(String hint) {
        mSearchEditText.setHint(hint);
	}
	
	public void setInputType(int inputType) {
        mSearchEditText.setInputType(inputType);
	}
	
	public String getText() {
		return mSearchEditText.getText().toString();
	}
    public void clear() {
        mSearchEditText.setText("");
    }
}
