Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:60382 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756365Ab2K0UXt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 15:23:49 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
CC: "Shen, Jackey" <Jackey.Shen@amd.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 27 Nov 2012 12:23:45 -0800
Subject: RE: Marvell Avastar 88W8797 firmware
Message-ID: <477F20668A386D41ADCC57781B1F70430D1367C9ED@SC-VEXCH1.marvell.com> (sfid-20121127_212352_614835_CAEFAE95)
References: <0C8FBB70FF40A94D98BE847F9C171A98033D23B0@SCYBEXDAG02.amd.com>
	<477F20668A386D41ADCC57781B1F7043083BBD6CA7@SC-VEXCH1.marvell.com>
 <CAMXE1-rrkh9qm5Hu7vwj3iTrkAg0uXQcU8ySMMBg5++ojJ==Ng@mail.gmail.com>
In-Reply-To: <CAMXE1-rrkh9qm5Hu7vwj3iTrkAg0uXQcU8ySMMBg5++ojJ==Ng@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrei,

> Do you mean here that 8797 might be connected via USB (currently I use
> 8787 via SDIO).

For 8797, yes, you can connect it via USB interface.
If you have a reference adapter board from Marvell you can change some jumper settings to select either SDIO or USB.

8787 doesn't support USB interface.

Regards,
Bing
