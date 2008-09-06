Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:36895 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694AbYIFXQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 19:16:40 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v2] p54usb: support LM87 firmwares
Date: Sun, 7 Sep 2008 01:19:44 +0200
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>, Tomas Winkler <tomasw@gmail.com>
References: <200809022139.12969.chunkeey@web.de> <200809041229.38538.chunkeey@web.de> <48C30ADF.6010708@lwfinger.net>
In-Reply-To: <48C30ADF.6010708@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809070119.45720.chunkeey@web.de> (sfid-20080907_011658_326508_9E2CE85C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 07 September 2008 00:57:35 Larry Finger wrote:
> Christian Lamparter wrote:
> > This patch adds the necessary changes to support LM87 firmwares.
>
> Do you have a URL for the LM87 firmware? After this patch was added, I
> tried the 2.5.11.0.arm and 2.13.1.0.arm files, but only the old
> 2.5.8.0 works. That is the one with the 'ping -s 1400' problem.
>
Yes

But, for newer firmwares you'll need "p54: better firmware support" (cc4b0cbf4ab)
as well. This changes were merged about 25-26 hours ago into wireless-testing,
the only thing that isn't in yet is 802.11a support....

the LM87 firmware is this one:
http://daemonizer.de/prism54/prism54-fw/fw-usb/2.13.1.0.arm.1

This link can be found on the driver's site too:
http://linuxwireless.org/en/users/Drivers/p54

Regards,
	Chr
