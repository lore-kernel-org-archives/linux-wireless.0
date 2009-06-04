Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([207.115.11.51]:62338 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZFDRwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 13:52:55 -0400
Message-ID: <4A2809F8.6020006@lwfinger.net>
Date: Thu, 04 Jun 2009 12:52:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rfkill: always init poll delayed work
References: <1244015729.7176.28.camel@johannes.local>	 <4A268DAC.4010805@lwfinger.net> <1244040913.4862.8.camel@johannes.local>	 <4A27DF95.50603@lwfinger.net> <1244128337.22576.81.camel@johannes.local>	 <4A27EF6C.8000208@lwfinger.net> <1244132396.22576.82.camel@johannes.local>	 <4A27F649.9080203@lwfinger.net> <1244133087.22576.86.camel@johannes.local>	 <4A27FB8D.5000605@lwfinger.net> <1244134635.22576.88.camel@johannes.local>
In-Reply-To: <1244134635.22576.88.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> Right. So we already have the problem in the old code, we just don't
> notice much... can we take the core up, check, and put it down again? Or
> I think it's GPIOs, can we query those via chipcommon when the 802.11
> core is down?

If you mean the check for the switch, that is an MMIO access. I think
that we can access it even if the 802.11 core is down.

Larry

