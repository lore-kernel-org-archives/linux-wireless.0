Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr720123.outbound.protection.outlook.com ([40.107.72.123]:16697
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726142AbeHONYn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 09:24:43 -0400
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Subject: [PATCH 0/2] brcmfmac: add FT support
Date: Wed, 15 Aug 2018 05:32:38 -0500
Message-Id: <1534329160-131774-1-git-send-email-chi-hsien.lin@cypress.com> (sfid-20180815_123310_032366_93C4A0CE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds FT and 4-way handshake offload support.

Chung-Hsien Hsu (2):
  brcmfmac: add FT-based AKMs in brcmf_set_key_mgmt() for FT support
  brcmfmac: add 4-way handshake offload detection for FT-802.1X

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 8 ++++++++
 drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h | 1 +
 2 files changed, 9 insertions(+)

-- 
2.1.0
