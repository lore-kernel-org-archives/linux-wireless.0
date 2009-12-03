Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:54399 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbZLCKis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 05:38:48 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 0/4] iwmc3200wifi updates for 2.6.33
Date: Thu,  3 Dec 2009 11:40:14 +0100
Message-Id: <cover.1259835655.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the last iwmc3200wifi update for 2.6.33, so all following 4 patches
are targeted at your wireless-testing tree.
This patchset aims at correctly enabling the iwmc3200 wimax-wifi (a.k.a. wiwi)
coexistence.

Samuel Ortiz (4):
  iwmc3200wifi: Update wiwi priority table
  iwmc3200wifi: Coex table command does not expect a response
  iwmc3200wifi: Add wifi-wimax coexistence mode as a module parameter
  iwmc3200wifi: Enable wimax core through module parameter

 drivers/net/wireless/iwmc3200wifi/commands.c |   22 +++++++++++++---------
 drivers/net/wireless/iwmc3200wifi/iwm.h      |    1 -
 drivers/net/wireless/iwmc3200wifi/main.c     |    8 +++++---
 3 files changed, 18 insertions(+), 13 deletions(-)

