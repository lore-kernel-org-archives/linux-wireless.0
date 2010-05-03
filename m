Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab0ECP3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 11:29:19 -0400
Subject: Re: [PATCH] rt2x00: remove USB-ID 148f:2573 from rt2500usb driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "rain_maker@root-forum.org" <rain_maker@root-forum.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <v2wa32f33a41005030813m36cbea0blf3963369a934cdac@mail.gmail.com>
References: <201005031624.45409.rain_maker@root-forum.org>
	 <v2wa32f33a41005030813m36cbea0blf3963369a934cdac@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 17:29:15 +0200
Message-ID: <1272900556.3614.42.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-03 at 17:13 +0200, Ivo Van Doorn wrote:
> > This trivial patch removes the id 148f:2573 from rt2500usb driver.

> The ID is confusing indeed, but unfortunately we can't remove this ID,
> since in the early days people did report they had to use the rt2500usb driver
> for these devices. So the majority of devices with this ID is indeed
> rt73usb, but not for all.

Since this seems to come up every couple of weeks, and none of us will
always be around to remember and answer it, how about capturing that in
a comment in the code? :)

johannes

