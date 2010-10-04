Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab0JDSbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:31:39 -0400
Subject: Re: OLPC XO-1 rfkill driver design
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@queued.net>
In-Reply-To: <AANLkTikfriP-KM1NqZuKV0Wvz8ew4rz9uCGMuJx2hzE0@mail.gmail.com>
References: <AANLkTin5zuxUY9ySYKrT9qD6cgV7eb7UhCjDYFzTUTeU@mail.gmail.com>
	 <1286181700.3620.1.camel@jlt3.sipsolutions.net>
	 <AANLkTikfriP-KM1NqZuKV0Wvz8ew4rz9uCGMuJx2hzE0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 20:31:37 +0200
Message-ID: <1286217097.3620.45.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 18:19 +0100, Daniel Drake wrote:
> On 4 October 2010 09:41, Johannes Berg <johannes@sipsolutions.net> wrote:
> > None of these seem to allow for automatic detection that the module is
> > needed? Is there maybe some platform device already that it could match?
> 
> Good point.
> I found a load of rfkill drivers in drivers/platform/x86 and spoke
> with the maintainer who agreed that the XO-1 driver should go there as
> well.
> As for the probing issue, good point, it can be solved with platform devices.
> 
> I sent some patches for review:
> http://article.gmane.org/gmane.linux.kernel/1044224
> http://article.gmane.org/gmane.linux.kernel/1044225

Looks sane enough to me.

johannes

