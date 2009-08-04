Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58172 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803AbZHDPqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 11:46:01 -0400
Date: Tue, 4 Aug 2009 11:41:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Joerg Albert <jal2@gmx.de>
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath5k: fix missing output in monitor mode after
	ifconfig up
Message-ID: <20090804154153.GB4995@tuxdriver.com>
References: <4A74C2B6.3070407@gmx.de> <20090802032019.GA25339@hash.localnet> <4A754562.8000107@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4A754562.8000107@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 02, 2009 at 09:50:58AM +0200, Joerg Albert wrote:
> Let ath5k_chan_set() always call ath5k_reset().
> This fixes the bug that we don't
> get any packets in monitor mode after:
>
> ifconfig wlan0 down
> iwconfig wlan0 mode monitor channel 1
> ifconfig wlan0 up
>
> but they arrive after
>
> iwconfig wlan0 channel 2
>
> Signed-off-by: Joerg Albert <jal2@gmx.de>

patching file drivers/net/wireless/ath/ath5k/base.c
Hunk #1 FAILED at 1071.
Hunk #2 FAILED at 1083.
Hunk #3 FAILED at 2804.
3 out of 3 hunks FAILED -- saving rejects to file drivers/net/wireless/ath/ath5k/base.c.rej

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
