Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39770 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab1ERCQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 22:16:04 -0400
Received: by ywe9 with SMTP id 9so217366ywe.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 19:16:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=napNyMOSKT-cDR79X4ZMka9bMsg@mail.gmail.com>
References: <19922.8044.978298.696663@gargle.gargle.HOWL>
	<BANLkTi=RvaQcTuvi+sXxNpOv6qYU_FvoEQ@mail.gmail.com>
	<19922.38456.333268.853074@gargle.gargle.HOWL>
	<BANLkTi=8JtAEO+49sgEAAkmGVJNmZmqBog@mail.gmail.com>
	<BANLkTi=napNyMOSKT-cDR79X4ZMka9bMsg@mail.gmail.com>
Date: Wed, 18 May 2011 10:16:02 +0800
Message-ID: <BANLkTinNmGPh6VNF28Lr8pYmCRUKbJG4Wg@mail.gmail.com> (sfid-20110518_041607_684591_F95B1485)
Subject: Re: [ath9k-devel] [PATCH 0/8] ath9k_htc patches
From: Adrian Chadd <adrian@freebsd.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Keith Berkoben <berkoben@gmail.com>, Sujith <m.sujith@gmail.com>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis.Rodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 May 2011 04:46, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> Patches go first into wireless-next, then stable stuff goes into
> wirless-2.6 (current RC), and then both of these get pulled into
> wireless-testing, which provides the RC fixes + the next bits, on a
> stable kernel (RC).
>
> Compat-wireless daily snapshots use linux-next so changes take a bit
> to propagate there.
>
> OpenWrt uses wireless-testing as the base tree, you can tell by
> loading the compat module, it will tell you the base tree and git tree
> tags that was used as source.

And some (eg Felix) will merge in immediate bugfixes into openwrt that
hasn't yet made it into a baked compat-wireless release.


Adrian
