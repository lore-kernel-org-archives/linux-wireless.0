Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([204.127.217.101]:55845 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZDBWHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 18:07:39 -0400
Message-ID: <49D536FA.2050307@lwfinger.net> (sfid-20090403_000743_781638_CE3E857F)
Date: Thu, 02 Apr 2009 17:06:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: rpurdie@rpsys.net
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] leds: Increase trigger name maximum size
References: <49d5059a.f3z10uf0HvyIItSz%Larry.Finger@lwfinger.net>
In-Reply-To: <49d5059a.f3z10uf0HvyIItSz%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> On my HP dv2815 laptop, the total length of the triggers for my b43legacy
> wireless device exceeds the maximum value of 50 defined in
> include/linux/leds.h. As a result, the list is garbled.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---

Richard,

Please drop this. That length change is a red herring. Something is corrupting
the list of triggers, but this length is not it.

Sorry for the noise.

Larry

