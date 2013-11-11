Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from AShevkov.infinet.ru ([91.191.225.92]:54091 "EHLO
	ashevkov.infinet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3KKJPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 04:15:43 -0500
Date: Mon, 11 Nov 2013 14:33:04 +0600
From: Alex Hacker <hacker@epn.ru>
To: Adrian Chadd <adrian@freebsd.org>
Cc: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	"simon@open-mesh.com" <simon@open-mesh.com>,
	Sven Eckelmann <sven@open-mesh.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [OpenWrt-Devel] ath9k: Deaf  when setting rxchainmask
Message-ID: <20131111083304.GB4987@infinet.ru> (sfid-20131111_101549_835154_4A460461)
References: <19772470.YgPhAz9cYD@bentobox> <87B8D697-4540-4D0E-975B-125531E6833B@net.t-labs.tu-berlin.de> <CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
Some combinations of masks is restricted for AR92xx series.
See the ar9003_hw_set_chain_masks(), it allows any value for rx/tx chain masks
for AR93xx chips. It is claimed the QCA9558 should support it at least at HW
level.
Alex.
