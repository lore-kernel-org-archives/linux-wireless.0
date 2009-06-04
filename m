Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([207.115.11.54]:57709 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760097AbZFDQ25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 12:28:57 -0400
Message-ID: <4A27F649.9080203@lwfinger.net>
Date: Thu, 04 Jun 2009 11:28:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rfkill: always init poll delayed work
References: <1244015729.7176.28.camel@johannes.local>	 <4A268DAC.4010805@lwfinger.net> <1244040913.4862.8.camel@johannes.local>	 <4A27DF95.50603@lwfinger.net> <1244128337.22576.81.camel@johannes.local>	 <4A27EF6C.8000208@lwfinger.net> <1244132396.22576.82.camel@johannes.local>
In-Reply-To: <1244132396.22576.82.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> But this is without the patch?! If yes that would confuse me.

My bad. That test was with the patch "[RFT 3/3] b43/legacy: port to
cfg80211 rfkill". Without it, everything works just fine. The LED
works and the radio follows the switch.

Sorry for the noise.

Now that I know the problem is in the patch, it should be easier to debug.

Larry
