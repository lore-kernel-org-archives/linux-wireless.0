Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.243]:50900 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750711AbXLVCAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 21:00:51 -0500
Received: by hs-out-2122.google.com with SMTP id 54so453224hsz.5
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2007 18:00:50 -0800 (PST)
Message-ID: <8999a3120712211800l29abd40n66ad9abab56390db@mail.gmail.com> (sfid-20071222_020055_079431_DCE306A7)
Date: Fri, 21 Dec 2007 18:00:50 -0800
From: "Chuck Tuffli" <ctuffli@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: drivers supporting AP mode
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1198282353.6630.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <8999a3120712211602r43d9c568naa09efcd7f410b2f@mail.gmail.com>
	 <1198282353.6630.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 21, 2007 4:12 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
...
> >  and was looking for hardware suggestions. There is a list of
> > drivers on http://linuxwireless.org/en/users/Drivers, but is it up to
> > date or are there additional drivers that now support AP
> > functionality?
>
> It's up to date but... mac80211 doesn't really support hostapd right
> now.

Ok, without hostapd I should still be able to setup an unencrypted AP, right?

With regard to driver choices, it looks like the b43 is the way to go
if I wanted to setup something that currently works.

---chuck
