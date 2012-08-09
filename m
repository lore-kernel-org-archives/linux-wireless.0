Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:58938 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759376Ab2HITmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 15:42:10 -0400
From: Marek Vasut <marex@denx.de>
To: Joseph Honold <mozzwald@gmail.com>
Subject: Re: Palm T|X Libertas Wifi problems Kernel 3.4.7 stable
Date: Thu, 9 Aug 2012 21:42:03 +0200
Cc: linux-wireless@vger.kernel.org
References: <CALSu_YrXF0iO0=+drmUzatGZUYkMxczF_J2Xw_CNqEY3fxJ5Bg@mail.gmail.com> <201208092026.03430.marex@denx.de> <CALSu_Yq77ED4d1ZwzSKFfP9ze_FnYKErSHrB+1pwjFvu1rypLQ@mail.gmail.com>
In-Reply-To: <CALSu_Yq77ED4d1ZwzSKFfP9ze_FnYKErSHrB+1pwjFvu1rypLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201208092142.04033.marex@denx.de> (sfid-20120809_214214_282919_5070CC97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Joseph Honold,

> > There's official 5.x.x firmware for 88w8381 in linux-firmware, use that.
> > V4 FW supplied by Palm isn't supported properly.
> 
> That did the trick. Thanks

You're welcome :)

So the V4 firmware support for 8381 is completely broken now? I think I'll 
submit a patch that removes the support for it altogether later on (and 
complains if you try to load V4 firmware). I recall I added some piece of code 
that tolerated the V4 FW, but it was maybe a code for tolerating V3 firmware on 
8305 even ... I'll have to check.

Best regards,
Marek Vasut
