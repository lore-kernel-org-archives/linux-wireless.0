Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbbIONq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 09:46:26 -0400
Date: Tue, 15 Sep 2015 06:46:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: remove unused variable
 g_num_total_switches
Message-ID: <20150915134625.GB22620@kroah.com> (sfid-20150915_154629_561513_7141B888)
References: <1442295237-12644-1-git-send-email-tony.cho@atmel.com>
 <20150915071337.GH12611@sudip-pc>
 <55F7D63B.3040502@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55F7D63B.3040502@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 15, 2015 at 05:26:35PM +0900, Tony Cho wrote:
> 
> 
> On 2015년 09월 15일 16:13, Sudip Mukherjee wrote:
> >On Tue, Sep 15, 2015 at 02:33:54PM +0900, Tony Cho wrote:
> >>From: Glen Lee <glen.lee@atmel.com>
> >>
> >>g_num_total_switches is never used so just delete it.
> >>
> >>Signed-off-by: Glen Lee <glen.lee@atmel.com>
> >>Signed-off-by: Tony Cho <tony.cho@atmel.com>
> >>---
> >you only deleted from the .h file but it still remains in
> >coreconfigurator.c
> >
> >regards
> >sudip
> 
> The variable was removed in previous patch (staging: wilc1000: remove unused variables) and the patch was sent
> but it's not accepted yet. So, you can find the variable still in c file.

I don't see that patch here in my queue :(

Please resend all of your outstanding patches, I think we are out of
sync somehow.

thanks,

greg k-h
