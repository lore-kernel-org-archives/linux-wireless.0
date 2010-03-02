Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23187 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab0CBHwr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 02:52:47 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 23:52:47 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19340.51272.987517.174933@gargle.gargle.HOWL>
Date: Tue, 2 Mar 2010 13:41:52 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] ath9k: Remove common module
In-Reply-To: <43e72e891003012338q7da06ac0o7ff6ed6398626dcb@mail.gmail.com>
References: <19339.35506.86567.739868@gargle.gargle.HOWL>
	<43e72e891003011524m4d14bb2ai550f5e07e5a11aa4@mail.gmail.com>
	<19340.37231.983326.296054@gargle.gargle.HOWL>
	<43e72e891003012338q7da06ac0o7ff6ed6398626dcb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> ChromeOs builds everything as built-in so in that case you will have
> both eventually enabled.

Right, in this case a small fix is needed.
I'll send a patch to link in the library only once.

> Although it may be a few common helpers it could grow to share common
> mac80211 helpers. After all, there are a few calls which could simply
> be shared.

I wanted to do this too, have a single mac80211 layer - but eventually,
there were just too many differences between the callbacks.

Sujith
