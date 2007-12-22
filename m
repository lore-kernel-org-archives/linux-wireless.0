Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:51858 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbXLVUqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 15:46:04 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1431881wah.23
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2007 12:46:04 -0800 (PST)
Message-ID: <1ba2fa240712221246r3571b4c5i837129be4b8447dd@mail.gmail.com> (sfid-20071222_204611_469088_8C67B527)
Date: Sat, 22 Dec 2007 22:46:04 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Chuck Tuffli" <ctuffli@gmail.com>
Subject: Re: drivers supporting AP mode
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <8999a3120712211800l29abd40n66ad9abab56390db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <8999a3120712211602r43d9c568naa09efcd7f410b2f@mail.gmail.com>
	 <1198282353.6630.1.camel@johannes.berg>
	 <8999a3120712211800l29abd40n66ad9abab56390db@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > It's up to date but... mac80211 doesn't really support hostapd right
> > now.
>
> Ok, without hostapd I should still be able to setup an unencrypted AP, right?
>
> With regard to driver choices, it looks like the b43 is the way to go
> if I wanted to setup something that currently works.
>

We have older version of mac80211 and  hostapd over (wext) running in
AP mode with iwl4965.
We will try to rebase it over current versions, with posting patches
very soon. If you want to help  reviewing, testing, anything
you are more then welcome.
Thanks
Tomas

>
> ---chuck
> -
