Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0077.outbound.protection.outlook.com ([104.47.40.77]:3946
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751002AbdFTTzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 15:55:47 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH 0/8] qtnfmac: add more features to driver
Date: Tue, 20 Jun 2017 22:55:09 +0300
Message-Id: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com> (sfid-20170620_215552_236840_3D12E3B3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds more features to qtnfmac driver including
the following major pieces:
 - updates for regulatory support
 - AP/VLAN support
 - dump_survey handler
 - channel_switch handler

bus.h        |    1 
 cfg80211.c   |  560 +++++++++++++++++++++++++++++++++++++++++++++++++----------
 cfg80211.h   |    4 
 commands.c   |  515 ++++++++++++++++++++++++++++++++++++++++++++++++------
 commands.h   |    5 
 core.c       |   83 ++++++++
 core.h       |   62 +++++-
 event.c      |   67 ++++++-
 pearl/pcie.c |    5 
 qlink.h      |  201 +++++++++++++++++++--
 qlink_util.c |   26 +-
 qlink_util.h |    2 
 util.c       |   74 +++++--
 util.h       |   34 ++-
 14 files changed, 1422 insertions(+), 217 deletions(-)
