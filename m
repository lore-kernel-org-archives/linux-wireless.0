Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaAFLXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:23:08 -0500
Message-ID: <1389007385.5891.9.camel@jlt4.sipsolutions.net> (sfid-20140106_122312_850698_1FE5EE59)
Subject: Re: Exporting the TSF to userland
From: Johannes Berg <johannes@sipsolutions.net>
To: Pierre Bourdon <delroth@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Jan 2014 12:23:05 +0100
In-Reply-To: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com> (sfid-20131231_052532_890939_E8ECD40B)
References: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com>
	 (sfid-20131231_052532_890939_E8ECD40B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-31 at 05:24 +0100, Pierre Bourdon wrote:
> Hello linux-wireless,
> 
> I'm a developer of libdrc, a project that allows Linux computers to
> control a Wii U GamePad. Because of how the device operates, our
> library needs to be able to read the TSF value of the access point
> device from userland.
> 
> We currently have a hacky patch that works for our use cases, but it
> would be a lot more convenient if that feature could be upstreamed.
> What would be the best way to proceed?

That patch ... let's say I think "hacky" is almost lauding it. :)

sysfs is a really bad place for this too, no other wireless APIs use
sysfs.

johannes

