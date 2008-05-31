Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lilly.inetgate.net ([193.33.21.198]:46922 "EHLO
	lilly.inetgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbYEaU2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2008 16:28:13 -0400
Message-ID: <4841B245.10502@Rondom.de> (sfid-20080531_222816_402053_1256A054)
Date: Sat, 31 May 2008 22:17:09 +0200
From: Andreas Gnau <Rondom@Rondom.de>
MIME-Version: 1.0
To: Ken Mandelberg <km@mathcs.emory.edu>
CC: linux-wireless@vger.kernel.org
Subject: Re: Is there any working 802.11N USB Nic?
References: <48419F4C.3010201@mathcs.emory.edu>
In-Reply-To: <48419F4C.3010201@mathcs.emory.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ken Mandelberg schrieb:
> I have an Airlink AWLL6080 (Ralink 2870). Is there any native work for
> this chipset? I've tried ndiswrapper with an XP driver, but that only
> connects in G mode.

There are native drivers by Ralink for this chipset on their website.
[1]. I don't know how well they work, though. Maybe the rt2x00-project
will work on this once the current rt2x00 drivers are completely finished.

NDISWrapper should also support 802.1n, so start a new thread in the
NDISWrapper support forum [2], if you need additional help.


[1] http://www.ralinktech.com/ralink/Home/Support/Linux.html
[2]
http://ndiswrapper.sourceforge.net/joomla/index.php?/component/option,com_fireboard/Itemid,34/
