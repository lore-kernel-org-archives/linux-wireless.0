Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52800 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2CJGk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 01:40:27 -0500
Received: by dajr28 with SMTP id r28so2359987daj.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 22:40:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d_58okToGOH146vDsgZ_Jf01iZAxDX0pxwBMGSo0BvZYg@mail.gmail.com>
References: <1331298825-22314-1-git-send-email-helmut.schaa@googlemail.com>
	<CAGXE3d_58okToGOH146vDsgZ_Jf01iZAxDX0pxwBMGSo0BvZYg@mail.gmail.com>
Date: Fri, 9 Mar 2012 22:40:26 -0800
Message-ID: <CAJ-Vmo=WLa6Lc7u4fjPNDjVP5MT9+OJ-qNP-zBL+T=ajOHSN7g@mail.gmail.com> (sfid-20120310_074030_820499_12358A63)
Subject: Re: [PATCH] mac80211: Disable MCS > 7 in minstrel_ht when STA uses
 static SMPS
From: Adrian Chadd <adrian@freebsd.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. hm, I was wondering about SMPS. Why not RTS-to-self? Wouldn't that
wake up the other RX chains?


adrian
