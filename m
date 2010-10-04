Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0JDIln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 04:41:43 -0400
Subject: Re: OLPC XO-1 rfkill driver design
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@queued.net>
In-Reply-To: <AANLkTin5zuxUY9ySYKrT9qD6cgV7eb7UhCjDYFzTUTeU@mail.gmail.com>
References: <AANLkTin5zuxUY9ySYKrT9qD6cgV7eb7UhCjDYFzTUTeU@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 10:41:40 +0200
Message-ID: <1286181700.3620.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,


> A)
> A module where the module_init logic is as follows:

> B)
> A module where module_init registers a platform driver

> (C)
> A module where module_init registers a platform driver, checks that

None of these seem to allow for automatic detection that the module is
needed? Is there maybe some platform device already that it could match?

> My instinct is to go for (A), but I can't find any other drivers that
> follow the same structure -- even though they could do. Perhaps
> there's a reason that I'm missing...

I don't think there are any rfkill drivers for (pseudo-)embedded
hardware yet, and I suspect the x86 ones all use DMI matching or
similar?

johannes

