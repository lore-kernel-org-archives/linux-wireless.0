Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:50327 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbcBWF3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 00:29:43 -0500
From: "Kim, Leo" <Leo.Kim@atmel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Park, Chris" <Chris.Park@atmel.com>,
	"Shin, Austin" <Austin.Shin@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
	"Cho, Tony" <Tony.Cho@atmel.com>,
	"Abozaeid, Adham" <Adham.Abozaeid@atmel.com>
Subject: RE: [PATCH RESEND 04/10] staging: wilc1000: removes unnecessary
 wilc_debug print log
Date: Tue, 23 Feb 2016 05:29:24 +0000
Message-ID: <74F3875218FC364C9618AB19CB60E9058004BF76@penmbx02.corp.atmel.com> (sfid-20160223_062946_918634_7E99E081)
References: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
 <1456116079-7161-4-git-send-email-leo.kim@atmel.com>
 <20160222104519.GR32153@mwanda>
 <74F3875218FC364C9618AB19CB60E9058004B81C@penmbx02.corp.atmel.com>
 <20160222144424.GD5273@mwanda>
In-Reply-To: <20160222144424.GD5273@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Dan,

Thank you your great comments.
I will be not forget your advice. 

Please understand that if you have a misunderstanding.

Thank you & Best Regards.
Leo

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Monday, February 22, 2016 11:44 PM
To: Kim, Leo <Leo.Kim@atmel.com>
Cc: gregkh@linuxfoundation.org; devel@driverdev.osuosl.org; Park, Chris <Chris.Park@atmel.com>; Shin, Austin <Austin.Shin@atmel.com>; linux-wireless@vger.kernel.org; Ferre, Nicolas <Nicolas.FERRE@atmel.com>; Cho, Tony <Tony.Cho@atmel.com>; Abozaeid, Adham <Adham.Abozaeid@atmel.com>
Subject: Re: [PATCH RESEND 04/10] staging: wilc1000: removes unnecessary wilc_debug print log

On Mon, Feb 22, 2016 at 11:42:42AM +0000, Kim, Leo wrote:
> Dear Dan,
> 
> This patch is subject "removes unnecessary wilc_debug print log".

I'm fine with you fixing it up in a later patch, but you should not be defending this patch as valid way to do things.

The rule is "do one thing at a time", not "do half a thing at a time."
In the original code the if statement was required because it was determining when to print, but now it is a confusing unneeded line of code.  I'm not asking for an additional unrelated cleanup for something that was already there in the original code.  It was this patch which introduced the problem (the stray unneeded line of code).

Also I had already asked you to redo this on Feb 19.

Part of the reason that we like people to "do one thing per patch" is that people promise they will clean things up in the future but they get distracted and forget.

regards,
dan carpenter


