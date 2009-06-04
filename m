Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:63609 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbZFDQvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 12:51:24 -0400
Message-ID: <4A27FB8D.5000605@lwfinger.net>
Date: Thu, 04 Jun 2009 11:51:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rfkill: always init poll delayed work
References: <1244015729.7176.28.camel@johannes.local>	 <4A268DAC.4010805@lwfinger.net> <1244040913.4862.8.camel@johannes.local>	 <4A27DF95.50603@lwfinger.net> <1244128337.22576.81.camel@johannes.local>	 <4A27EF6C.8000208@lwfinger.net> <1244132396.22576.82.camel@johannes.local>	 <4A27F649.9080203@lwfinger.net> <1244133087.22576.86.camel@johannes.local>
In-Reply-To: <1244133087.22576.86.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> Would you do the same test with the uevents w/o the patch? I suspect
> that you won't get the event at the right spot.

Yes. Without the patch and the interface UP or DOWN,
/sys/class/rfkill/rfkill0/uevent always shows RFKILL_STATE=1, no
matter what state the switch is in.

FYI, my switch is a slider with off to the left and on to the right.

Larry

