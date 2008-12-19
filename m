Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:40349 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYLSREU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 12:04:20 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: p54usb problems
Date: Fri, 19 Dec 2008 18:03:58 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <200812190306.52254.chunkeey@web.de> <494BC173.7060703@lwfinger.net>
In-Reply-To: <494BC173.7060703@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812191803.59129.chunkeey@web.de> (sfid-20081219_180423_777368_5B88E2F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 19 December 2008 16:44:51 Larry Finger wrote:
> The second version runs here. My impression was that the flood ping runs a bit
> more smoothly with fewer times that 6-8 dots are printed before it catches up.
6-8 dots?
It's 0 to 1 dot here. And it only goes up if I kill the connection. 

> My stress test still fails. I'm running firmware rev 2.13.1.0. Is there a better
> one to try?
by "stress test fails", do you mean the sudden stall or the warnings about page allocation?
because can you please try: ping X.y.z -s 1400 and see if it stalls instantly?

Well, there's:
2.13.24.0 ( http://daemonizer.de/prism54/prism54-fw/fw-usb/2.13.24.0.lm87.arm )
But, I bet that it won't do anything at all...

Regards,
	Chr
