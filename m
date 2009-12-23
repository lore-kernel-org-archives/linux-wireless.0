Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37367 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZLWEiB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 23:38:01 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 20:38:01 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19249.41596.778604.908714@gargle.gargle.HOWL>
Date: Wed, 23 Dec 2009 10:24:20 +0530
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner case
In-Reply-To: <43e72e890912221854s5f06a0d2jcfffb1cc8d857347@mail.gmail.com>
References: <20091222022355.GA32508@bombadil.infradead.org>
	<19248.19829.293087.367661@gargle.gargle.HOWL>
	<20091222155005.GA4385@tux>
	<20091222162055.GC4385@tux>
	<20091222165528.GE4385@tux>
	<20091222175939.GF4385@tux>
	<43e72e890912221716r64ea4542qd747302b536a3156@mail.gmail.com>
	<19249.34294.19925.963051@gargle.gargle.HOWL>
	<43e72e890912221854s5f06a0d2jcfffb1cc8d857347@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Rodriguez wrote:
> Did you see the last one? It turns out its the only config option
> passed by mac8021 I've seen so far so my commit log should change.

Right, that patch should work.
So the one I sent out and this one fixes the issue ?

Sujith
