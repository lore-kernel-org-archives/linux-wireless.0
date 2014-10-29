Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203AbaJ2PmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:14 -0400
Date: Wed, 29 Oct 2014 17:38:12 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, cmroliv@gmail.com,
	gdonald@gmail.com, standby24x7@gmail.com, ninox@posteo.net,
	Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/2] staging: rtl8723au: core: pointer issue
Message-ID: <20141029093812.GB10589@kroah.com> (sfid-20141029_164251_602168_12663CEB)
References: <1414340266-4502-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414340266-4502-1-git-send-email-paulmcquad@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 26, 2014 at 04:17:46PM +0000, Paul McQuade wrote:
> ERROR: "foo *	bar" should be "foo *bar"
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_efuse.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Again with the odd subject :(
