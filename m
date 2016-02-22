Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37087 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbcBVOor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 09:44:47 -0500
Date: Mon, 22 Feb 2016 17:44:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Kim, Leo" <Leo.Kim@atmel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Park, Chris" <Chris.Park@atmel.com>,
	"Shin, Austin" <Austin.Shin@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
	"Cho, Tony" <Tony.Cho@atmel.com>,
	"Abozaeid, Adham" <Adham.Abozaeid@atmel.com>
Subject: Re: [PATCH RESEND 04/10] staging: wilc1000: removes unnecessary
 wilc_debug print log
Message-ID: <20160222144424.GD5273@mwanda> (sfid-20160222_154506_133503_4C229BA3)
References: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
 <1456116079-7161-4-git-send-email-leo.kim@atmel.com>
 <20160222104519.GR32153@mwanda>
 <74F3875218FC364C9618AB19CB60E9058004B81C@penmbx02.corp.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <74F3875218FC364C9618AB19CB60E9058004B81C@penmbx02.corp.atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 22, 2016 at 11:42:42AM +0000, Kim, Leo wrote:
> Dear Dan,
> 
> This patch is subject "removes unnecessary wilc_debug print log".

I'm fine with you fixing it up in a later patch, but you should not be defending
this patch as valid way to do things.

The rule is "do one thing at a time", not "do half a thing at a time."
In the original code the if statement was required because it was
determining when to print, but now it is a confusing unneeded line of
code.  I'm not asking for an additional unrelated cleanup for something that was
already there in the original code.  It was this patch which introduced
the problem (the stray unneeded line of code).

Also I had already asked you to redo this on Feb 19.

Part of the reason that we like people to "do one thing per patch" is that
people promise they will clean things up in the future but they get distracted
and forget.

regards,
dan carpenter


