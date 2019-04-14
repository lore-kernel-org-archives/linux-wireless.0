Return-Path: <SRS0=0lX+=SQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD02C10F13
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 18:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C90520848
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 18:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfDNSmZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Apr 2019 14:42:25 -0400
Received: from hera.iit.uni-miskolc.hu ([193.6.5.4]:42012 "EHLO
        hera.iit.uni-miskolc.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfDNSmZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Apr 2019 14:42:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by hera.iit.uni-miskolc.hu (Postfix) with ESMTP id 2840E129;
        Sun, 14 Apr 2019 20:36:55 +0200 (CEST)
X-Virus-Scanned: Kamavis at iit.uni-miskolc.hu
Received: from hera.iit.uni-miskolc.hu ([127.0.0.1])
        by localhost (hera.iit.uni-miskolc.hu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id drNquAQMtxIR; Sun, 14 Apr 2019 20:36:47 +0200 (CEST)
Received: from titan.hitronhub.home (unknown [IPv6:2a02:8109:a180:2158:226:9eff:fe30:2af8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: szucst@iit.uni-miskolc.hu)
        by hera.iit.uni-miskolc.hu (Postfix) with ESMTPSA id BD8C9126;
        Sun, 14 Apr 2019 20:36:45 +0200 (CEST)
From:   =?UTF-8?q?Tam=C3=A1s=20Sz=C5=B1cs?= <tszucs@protonmail.ch>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:MARVELL MWIFIEX WIRELESS
        DRIVER), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     Cathy Luo <cluo@marvell.com>, Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Hemantkumar Suthar <shemant@marvell.com>,
        =?UTF-8?q?Tam=C3=A1s=20Sz=C5=B1cs?= <tszucs@protonmail.ch>
Subject: [PATCH 0/1] mwifiex: add support for SD8987 chipset
Date:   Sun, 14 Apr 2019 20:36:40 +0200
Message-Id: <20190414183641.7539-1-tszucs@protonmail.ch>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi All,

Changes here have been tested with u-blox JODY-W2XX and Marvell
TB-AQB8987-QFN-EPA-2A. It would be great to have driver support upstream.
Kindly review.

Kind regards,
Tamas

Tamás Szűcs (1):
  mwifiex: add support for SD8987 chipset

 drivers/net/wireless/marvell/mwifiex/Kconfig |  4 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c  |  5 ++
 drivers/net/wireless/marvell/mwifiex/sdio.h  | 69 ++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 2 deletions(-)

-- 
2.11.0

