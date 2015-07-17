Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f43.google.com ([209.85.216.43]:34374 "EHLO
	mail-vn0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbbGQRWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 13:22:14 -0400
Received: by vnds125 with SMTP id s125so3329625vnd.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2015 10:22:13 -0700 (PDT)
MIME-Version: 1.0
From: Su Kang Yin <paradyse@gmail.com>
Date: Sat, 18 Jul 2015 01:21:42 +0800
Message-ID: <CAHjFwoAMWO+2SUgv2EZ5D+04Sb33TnPveGz7pJ-pq=NUHCt2Pw@mail.gmail.com> (sfid-20150717_192217_581609_B4A0C5F8)
Subject: linux-4.1.2 is missing "ath9k: fix DMA stop sequence for AR9003+"
To: nbd@openwrt.org, ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

linux-4.1.2 is missing "ath9k: fix DMA stop sequence for AR9003+"

should we pick this?

commit 27a0cc563105b7346c91520d36aabf721e50878d
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Tue Jun 2 10:38:32 2015 +0200

    ath9k: fix DMA stop sequence for AR9003+

    [ Upstream commit 300f77c08ded96d33f492aaa02549103852f0c12 ]

    AR93xx and newer needs to stop rx before tx to avoid getting the DMA
    engine or MAC into a stuck state.
    This should reduce/fix the occurence of "Failed to stop Tx DMA" logspam.

    Cc: stable@vger.kernel.org
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Thanks,
cantona
