Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934167AbaJ2PmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:11 -0400
Date: Wed, 29 Oct 2014 17:34:46 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jes.Sorensen@redhat.com,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH][V2] Staging:rtl8723au: open/closed brace issue
Message-ID: <20141029093446.GA32663@kroah.com> (sfid-20141029_164409_321812_C609DEE4)
References: <1414336222-2885-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414336222-2885-1-git-send-email-paulmcquad@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 26, 2014 at 03:10:22PM +0000, Paul McQuade wrote:
> ERROR: that open brace { should be on the previous line
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_ap.c | 130 ++++++++++----------------------
>  1 file changed, 40 insertions(+), 90 deletions(-)

This doesn't apply to my tree :(
