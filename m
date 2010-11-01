Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61016 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0KARMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 13:12:36 -0400
Received: by gxk23 with SMTP id 23so3344154gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 10:12:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CCEF06B.5030708@openwrt.org>
References: <AANLkTik=LvRZja13SGOpicVjbyf6chRtTD-RkvSm2VcE@mail.gmail.com>
	<8762whrqvm.fsf@gmail.com>
	<AANLkTin1oXb8mkyxZgn5jEy7FJF9BPpiuJ1Q7j9XCDYz@mail.gmail.com>
	<AANLkTimBf6PRdTNUpx1HLu6Q70onHi3YhqKOYQ2Rk-yF@mail.gmail.com>
	<4CCEF06B.5030708@openwrt.org>
Date: Mon, 1 Nov 2010 18:12:35 +0100
Message-ID: <AANLkTinjUiA968d477=Dri7AoqippEh5=cAP-XXze4GK@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k: race conditions in dma
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Ben Gamari <bgamari@gmail.com>, ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/1 Felix Fietkau <nbd@openwrt.org>
> > My TX PCU patches for ath9k are not merged yet, try those or wait
> > until John merges them.
> They are merged in OpenWrt. Björn, which OpenWrt revision did you use in
> your tests?
>
> - Felix

I'm based on openwrt/trunk@23720 when I run code. But when I read code
I'm looking at the latest wireless-testing (and trying to keep track
of pending patches on linux-wireless). I will apply the TX PCU patch
and see if that changes my bad fuzzy feeling.

/Björn
