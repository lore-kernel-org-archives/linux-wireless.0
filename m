Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35450 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753428AbdKXLri (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Nov 2017 06:47:38 -0500
Date: Fri, 24 Nov 2017 12:47:42 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: venkat.prashanth2498@gmail.com
Cc: linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH v3] rtlwifi:rtl8723ae:add the function name to the
 printouts
Message-ID: <20171124114742.GA24008@kroah.com> (sfid-20171124_124741_047257_831AE789)
References: <1511523680-5033-1-git-send-email-venkat.prashanth2498@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1511523680-5033-1-git-send-email-venkat.prashanth2498@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 24, 2017 at 05:11:20PM +0530, venkat.prashanth2498@gmail.com wrote:
> From: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>
> 
> Prefer and make it generic by using %s and __func__
> to print function name
> 
> Change Log:
> 
> v2:
> a. RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "\n");
> The function name is not necessary in above code
> according to conditions as mentioned in comments.
> 
> b. modified the commit message according
> to suggested comments.
> 
> c. fixed the alignment issues.
> 
> v1:
> a. Sign-off line is saperated from subject
> line from earlier patch version.
> 
> Signed-off-by: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 6 +++---

Why are you sending me this patch???

confused,

greg k-h
