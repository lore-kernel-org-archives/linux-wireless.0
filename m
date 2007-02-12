Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:41012 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965427AbXBLWUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 17:20:38 -0500
Message-ID: <45D0E834.4050800@lwfinger.net>
Date: Mon, 12 Feb 2007 16:20:36 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <200702120150.59747.rjw@sisk.pl> <45CFC062.1050301@lwfinger.net> <200702122148.58101.rjw@sisk.pl>
In-Reply-To: <200702122148.58101.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafael J. Wysocki wrote:
> On Monday, 12 February 2007 02:18, Larry Finger wrote:
>> Rafael J. Wysocki wrote:
>>> It doesn't help in my case.  The behavior is similar to that without the patch,
>>> but also with the patch it loses the association entirely.
>> Thanks for trying.
>>
>> Do you have this patch installed? If you do, please try increasing the 100 to 200.
> 
> Hm, but it wouldn't help to get the microcode to respond after the resume ...

Yes it would. That count is how long the system waits for the firmware to respond.

> I'm still thinking the problem is with the firmware.  Where exactly is it
> stored?

In the memory of the microprocessor on the card.

Please do what I asked.

Larry
