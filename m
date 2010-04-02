Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56804.mail.re3.yahoo.com ([66.196.97.78]:21603 "HELO
	web56804.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757392Ab0DBGnA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 02:43:00 -0400
Message-ID: <336206.19355.qm@web56804.mail.re3.yahoo.com>
Date: Thu, 1 Apr 2010 23:42:59 -0700 (PDT)
From: Golden <goldenstranger@yahoo.com>
Subject: Re: firmware_loading_store: vmap() failed, broken firmware with kernles .27 - .30
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I realize that it's an important issue, but I don't have
> time to look
> for a solution right now.  I did my part by confirming
> the problem on an
> 2.6.28.10 kernel.  I don't see it on other kernels,
> but since it's a
> race condition, I cannot say definitely that the same
> condition cannot
> happen on another system running a newer kernel.
> 
> -- 
> Regards,
> Pavel Roskin


Interesting scenario we have here. I confirm the race condition in 2.6.27 and 2.6.30, it appears to be gone in 2.6.31 /Ubuntu 9.10/, it appears to be present in Ubuntu 10.04 /2.6.32/ beta and then it disappears again in 2.6.33 /don't know about .34rc/.

Here's a bug report back from February pertaining to 2.6.32:
https://bugzilla.kernel.org/show_bug.cgi?id=15294



      
