Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28147 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbZJPVZ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 17:25:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/10] iwlwifi driver updates 10/16/2009
Date: Fri, 16 Oct 2009 14:25:48 -0700
Message-Id: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes include making the current power saving state available via
debugfs and reworking static power save. This series also commence the work to
support 6x50 devices. The rest is code cleanup and preparation for future
changes.

Abhijeet Kolekar (1):
      iwl3945: disable all tx fifos

Reinette Chatre (3):
      iwlwifi: move iwl_setup_mac to iwlagn
      iwlwifi: move rate scaling structures to header file
      iwlagn: store station rate scale information in mac80211 station structure

Wey-Yi Guy (6):
      iwlwifi: show current power save status reported by uCode
      iwlwifi: identify eeprom version for 6x50 series NIC
      iwlwifi: fix incorrect otp blocks number for 6x50 series
      iwlwifi: set auto clock gate disable bit for 6x00/6x50 series
      iwlwifi: no chain noise support for 6x50 series
      iwlwifi: rework for static power save

Reinette

