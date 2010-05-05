Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:63177 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab0EEFZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 01:25:59 -0400
Received: by pzk42 with SMTP id 42so1220532pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 22:25:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100504195500.GH2624@tux>
References: <4BDFD3C1.4000209@openwrt.org> <u2q43e72e891005041109i5106ba24ma7345c4f4c4fde21@mail.gmail.com>
	<4BE0773A.8090009@openwrt.org> <20100504195500.GH2624@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 4 May 2010 22:25:37 -0700
Message-ID: <h2h43e72e891005042225n1be34430xabc8be568daba025@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix another source of corrupt frames
To: Felix Fietkau <nbd@openwrt.org>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 4, 2010 at 12:55 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> ath9k_rx_accept

So this guys is called only within ath9k_cmn_rx_skb_preprocess() and
that is only called by ath9k.. so yeah ath9k_htc no longer uses this
stuff. The patch is fine, please do merge John.

  Luis
