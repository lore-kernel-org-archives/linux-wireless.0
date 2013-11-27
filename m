Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49855 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3K0GQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 01:16:56 -0500
Received: by mail-ie0-f182.google.com with SMTP id as1so11166484iec.27
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 22:16:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385498361.4177.4.camel@jlt4.sipsolutions.net>
References: <1385409372-4229-1-git-send-email-janusz.dziedzic@tieto.com>
	<1385409372-4229-4-git-send-email-janusz.dziedzic@tieto.com>
	<201311261550.14953.sw@simonwunderlich.de>
	<CAFED-jmmkA2j4YRhFj7MXgZBgLJrofn1RGnbORtGDzB8wOErfw@mail.gmail.com>
	<1385498361.4177.4.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Nov 2013 07:16:56 +0100
Message-ID: <CAFED-jnMOWKZz1pHpvKmxu7ZZo0KGpomw2v8ug_oqpsdGBbOwQ@mail.gmail.com> (sfid-20131127_071700_163978_DAE37BA3)
Subject: Re: [PATCH v3 4/4] cfg80211: DFS use 10 minutes CAC when weather channels
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/11/26 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2013-11-26 at 21:19 +0100, Janusz Dziedzic wrote:
>
>> ath.ko already disable weather channels by default.
>> But in case driver will pass DFS certification (meet all requirements)
>> - why not use weather channels?
>
> Since I'm a lazy bastard - can you demonstrate such a driver? I'm
> guessing not (immediately), so I'll drop your patches for now - maybe
> better to go back to the drawing board and get all of this into regdb
> etc. Doesn't seem critical to get it into the kernel now, if nobody
> really supports it anyway ...
>

I could say something more after DFS tests.
What about patch 1 and 2?

BR
Janusz
