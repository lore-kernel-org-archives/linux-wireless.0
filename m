Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbINEZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 00:25:07 -0400
Date: Sun, 13 Sep 2015 21:25:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH v2 1/2] staging: wilc1000: remove unused enum
Message-ID: <20150914042506.GB26591@kroah.com> (sfid-20150914_062512_185038_1242D07D)
References: <1441940660-5925-1-git-send-email-tony.cho@atmel.com>
 <1441940660-5925-2-git-send-email-tony.cho@atmel.com>
 <20150912023503.GA32162@kroah.com>
 <55F622F6.7010803@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55F622F6.7010803@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2015 at 10:29:26AM +0900, Tony Cho wrote:
> 
> 
> On 2015년 09월 12일 11:35, Greg KH wrote:
> >On Fri, Sep 11, 2015 at 12:04:19PM +0900, Tony Cho wrote:
> >>From: Glen Lee <glen.lee@atmel.com>
> >>
> >>This patch removes a unused enum tenuFrameClass.
> >>
> >>Signed-off-by: Glen Lee <glen.lee@atmel.com>
> >>Signed-off-by: Tony Cho <tony.cho@atmel.com>
> >>---
> >>  drivers/staging/wilc1000/coreconfigurator.c | 8 --------
> >>  1 file changed, 8 deletions(-)
> >I already applied this, why resend it?
> >
> >greg k-h
> 
> This is one of series for the "[PATCH v2 2/2] staging: wilc1000: coreconfigurator.c: remove unused function".
> That's why it was sent to you.

But you sent it as a part of a different series, why do that?

When you do a v2 patch, please be specific, resend the whole series.
Otherwise how am I supposed to know what to do?  Remember, I get
hundreds of patches to review and handle every day, you need to be very
obvious as to what I need to do otherwise I will get it wrong :)

greg k-h
