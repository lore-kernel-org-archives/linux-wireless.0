Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33966 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752028AbdKTTbq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 14:31:46 -0500
Date: Mon, 20 Nov 2017 20:31:51 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: venkat.prashanth2498@gmail.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        chaoming_li@realsil.com.cn
Subject: Re: [PATCH] rtlwifi:rtl8723ae: Fix embedded function names with
 __func__ Prefer and make it generic by using %s and __func__ to print
 functions name instead of embedding functions name in print statements
Message-ID: <20171120193151.GD2780@kroah.com> (sfid-20171120_203149_708717_77713B44)
References: <1511181199-4638-1-git-send-email-venkat.prashanth2498@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1511181199-4638-1-git-send-email-venkat.prashanth2498@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 20, 2017 at 06:03:19PM +0530, venkat.prashanth2498@gmail.com wrote:
> From: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>
> 
> ---

Something when really wrong when you created your patch :(

Please always send it to yourself first, and of course, use
scripts/checkpatch.pl to ensure you did not do anything wrong (like was
done here...)

good luck!

greg k-h
