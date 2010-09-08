Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21795 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab0IHVba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 17:31:30 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 14:31:24 -0700
Date: Wed, 8 Sep 2010 14:31:28 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Nikitas Angelinas <nikitasangelinas@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] drivers/net/wireless/ath/ath9k: use ARRAY_SIZE
 macro in ani.c
Message-ID: <20100908213128.GD1783@tux>
References: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
 <1283981142-5062-1-git-send-email-nikitasangelinas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1283981142-5062-1-git-send-email-nikitasangelinas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 08, 2010 at 02:25:42PM -0700, Nikitas Angelinas wrote:
> Replace (sizeof(ofdm_level_table)/sizeof(ofdm_level_table[0]) with
> ARRAY_SIZE(ofdm_level_table), and (sizeof(cck_level_table)/
> sizeof(cck_level_table[0]) with ARRAY_SIZE(cck_level_table) in
> drivers/net/wireless/ath/ath9k/ani.c
> 
> Signed-off-by: Nikitas Angelinas <nikitasangelinas@gmail.com>

Sure.

  Luis
