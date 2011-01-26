Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:42931 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab1AZI3b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 03:29:31 -0500
From: juuso.oikarinen@nokia.com
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] wl12xx: Enable .11h 
Date: Wed, 26 Jan 2011 10:29:23 +0200
Message-Id: <1296030565-23778-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The .11h features are mandatory along with .11a items. These patches add some
of missing .11h stuff (major parts for DFS and TPC.)

However, some things are still to TODO after these:
 - Quieting
 - TPC Basic reporting - currently mac80211 is always responding with a 
   'refused' status, but that is not exactly in the spirit of the .11h spec



Juuso Oikarinen (2):
  wl12xx: Enable the IEEE80211_HW_SPECTRUM_MGMT hw flag
  wl12xx: Add a rule for WLAN_EID_PWR_CONSTRAINT in the beacon filter

 drivers/net/wireless/wl12xx/main.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

