Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([207.115.11.52]:41566 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759883AbZDJDIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 23:08:47 -0400
Message-ID: <49DEB82E.4070900@lwfinger.net> (sfid-20090410_050848_982458_CDB50041)
Date: Thu, 09 Apr 2009 22:08:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43 rfkill LED broken in 2.6.30-rc1 from wireless-testing
References: <49DE6ABE.30207@lwfinger.net>
In-Reply-To: <49DE6ABE.30207@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Johannes,
> 
> Boy is the rfkill subsystem fragile.
> 
> After all our debugging of the control of the b43 LED with the rfkill switch, it
> is broken again with 2.6.30-rc1.

I found the problem and will be submitting a patch ASAP.

Larry

