Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36627 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbbIOOGv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 10:06:51 -0400
Received: by padhk3 with SMTP id hk3so177793364pad.3
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2015 07:06:51 -0700 (PDT)
Date: Tue, 15 Sep 2015 19:36:43 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tony Cho <tony.cho@atmel.com>, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: remove unused variable
 g_num_total_switches
Message-ID: <20150915140643.GB7996@sudip-pc> (sfid-20150915_160654_629507_956DFDDD)
References: <1442295237-12644-1-git-send-email-tony.cho@atmel.com>
 <20150915071337.GH12611@sudip-pc>
 <55F7D63B.3040502@atmel.com>
 <20150915134625.GB22620@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150915134625.GB22620@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 15, 2015 at 06:46:25AM -0700, Greg KH wrote:
> On Tue, Sep 15, 2015 at 05:26:35PM +0900, Tony Cho wrote:
> > 
> > 
> > On 2015년 09월 15일 16:13, Sudip Mukherjee wrote:
> > >On Tue, Sep 15, 2015 at 02:33:54PM +0900, Tony Cho wrote:
> > >>From: Glen Lee <glen.lee@atmel.com>
> > >>
> > >>g_num_total_switches is never used so just delete it.
> > >>
> > >>Signed-off-by: Glen Lee <glen.lee@atmel.com>
> > >>Signed-off-by: Tony Cho <tony.cho@atmel.com>
> > >>---
> > >you only deleted from the .h file but it still remains in
> > >coreconfigurator.c
> > >
> > >regards
> > >sudip
> > 
> > The variable was removed in previous patch (staging: wilc1000: remove unused variables) and the patch was sent
> > but it's not accepted yet. So, you can find the variable still in c file.
> 
> I don't see that patch here in my queue :(
> 
> Please resend all of your outstanding patches, I think we are out of
> sync somehow.
This was the series of 7 patches and the first patch was
"remove PANDA_BOARD".
And the series is indeed not applied.

patch 7/7 was removing g_num_total_switches from the .c file, while
resending please modify and remove it from the .h file also.

And when your patch depends on some previous unapplied patch it will be
better if you can mention that in the comments.

regards
sudip
