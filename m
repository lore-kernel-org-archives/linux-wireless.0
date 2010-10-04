Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38656 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab0JDRTx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 13:19:53 -0400
Received: by ewy23 with SMTP id 23so2013860ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 10:19:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286181700.3620.1.camel@jlt3.sipsolutions.net>
References: <AANLkTin5zuxUY9ySYKrT9qD6cgV7eb7UhCjDYFzTUTeU@mail.gmail.com>
	<1286181700.3620.1.camel@jlt3.sipsolutions.net>
Date: Mon, 4 Oct 2010 18:19:49 +0100
Message-ID: <AANLkTikfriP-KM1NqZuKV0Wvz8ew4rz9uCGMuJx2hzE0@mail.gmail.com>
Subject: Re: OLPC XO-1 rfkill driver design
From: Daniel Drake <dsd@laptop.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 October 2010 09:41, Johannes Berg <johannes@sipsolutions.net> wrote:
> None of these seem to allow for automatic detection that the module is
> needed? Is there maybe some platform device already that it could match?

Good point.
I found a load of rfkill drivers in drivers/platform/x86 and spoke
with the maintainer who agreed that the XO-1 driver should go there as
well.
As for the probing issue, good point, it can be solved with platform devices.

I sent some patches for review:
http://article.gmane.org/gmane.linux.kernel/1044224
http://article.gmane.org/gmane.linux.kernel/1044225

Thanks for your input!
Daniel
