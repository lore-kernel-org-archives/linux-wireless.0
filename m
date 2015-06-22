Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33919 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbbFVLnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 07:43:32 -0400
Received: by lbnk3 with SMTP id k3so782243lbn.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 04:43:31 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, nbd@openwrt.org, sujith@msujith.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 0/3] ath9k: P2P patches when chanctx used
Date: Mon, 22 Jun 2015 13:43:02 +0200
Message-Id: <1434973385-15865-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150622_134335_978857_825DE73E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patches for problems I hit during P2P tests when
multichannel used (driver loaded with use_chanctx=1).

Janusz Dziedzic (3):
  ath9k: handle RoC abort correctly
  ath9k: make rxfilter per HW
  ath9k: advertise p2p dev support when chanctx

 drivers/net/wireless/ath/ath9k/ath9k.h   |  3 ++-
 drivers/net/wireless/ath/ath9k/channel.c |  3 ++-
 drivers/net/wireless/ath/ath9k/init.c    |  6 +++++-
 drivers/net/wireless/ath/ath9k/main.c    |  2 +-
 drivers/net/wireless/ath/ath9k/recv.c    | 12 ++++++------
 5 files changed, 16 insertions(+), 10 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
