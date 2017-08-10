Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32919 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751456AbdHJMpD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 08:45:03 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 0/2] Avoid unnecessary usage of random_mac
Date: Thu, 10 Aug 2017 18:11:24 +0530
Message-ID: <1502368886-16539-1-git-send-email-gbhat@marvell.com> (sfid-20170810_144506_654376_182A0A77)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series addresses unnecessary usage of random_mac from
user scan_request.

Ganapathi Bhat (2):
  mwifiex: do not use random MAC for pre-association scanning
  mwifiex: check for NL80211_SCAN_FLAG_RANDOM_ADDR during hidden SSID
    scan

 drivers/net/wireless/marvell/mwifiex/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
1.9.1
