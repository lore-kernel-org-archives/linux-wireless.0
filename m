Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43596 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab3KZUjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 15:39:23 -0500
Message-ID: <1385498361.4177.4.camel@jlt4.sipsolutions.net> (sfid-20131126_213926_499068_9D34FE7C)
Subject: Re: [PATCH v3 4/4] cfg80211: DFS use 10 minutes CAC when weather
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 26 Nov 2013 21:39:21 +0100
In-Reply-To: <CAFED-jmmkA2j4YRhFj7MXgZBgLJrofn1RGnbORtGDzB8wOErfw@mail.gmail.com> (sfid-20131126_212001_183552_B950E562)
References: <1385409372-4229-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1385409372-4229-4-git-send-email-janusz.dziedzic@tieto.com>
	 <201311261550.14953.sw@simonwunderlich.de>
	 <CAFED-jmmkA2j4YRhFj7MXgZBgLJrofn1RGnbORtGDzB8wOErfw@mail.gmail.com>
	 (sfid-20131126_212001_183552_B950E562)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-26 at 21:19 +0100, Janusz Dziedzic wrote:

> ath.ko already disable weather channels by default.
> But in case driver will pass DFS certification (meet all requirements)
> - why not use weather channels?

Since I'm a lazy bastard - can you demonstrate such a driver? I'm
guessing not (immediately), so I'll drop your patches for now - maybe
better to go back to the drawing board and get all of this into regdb
etc. Doesn't seem critical to get it into the kernel now, if nobody
really supports it anyway ...

johannes

