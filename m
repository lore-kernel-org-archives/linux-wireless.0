Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63212 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab2KSRQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 12:16:36 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so5033286oag.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 09:16:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353344601.18299.31.camel@jlt4.sipsolutions.net>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	<1353343170-26516-9-git-send-email-eliad@wizery.com>
	<1353344601.18299.31.camel@jlt4.sipsolutions.net>
Date: Mon, 19 Nov 2012 19:16:35 +0200
Message-ID: <CAB3XZEepFkTNZMAzB+Jy9R4wSzAyQuNVHdWcdHMoRN+FRe5=9A@mail.gmail.com> (sfid-20121119_181639_059585_1615A170)
Subject: Re: [PATCH 08/15] wlcore: add chanctx implementation
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 7:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
>> Add some basic chanctx implementation.
>
> This patch will leave the driver in a broken state, and in fact probably
> crashing trying to use hw.conf.channel.
>
you are right. i'm taking care of these in the following patches.
i preferred splitting the patches for clarity instead of squashing
them all into one big patch (removing hw.conf.channel references
before implementing chanctx will break the driver as well).
i guess i can squash them in this case, but i'm not sure it will
really help, as other intermediate patches in this patchset might
still break some functionality of the driver.

i don't mind either way. whatever Luca will prefer :)
(maybe keeping it that way for review, and only squashing them on apply?)

Eliad.
