Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZIQRnx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/13] iwlwifi driver updates 09/17/2009
Date: Thu, 17 Sep 2009 10:43:43 -0700
Message-Id: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include more patches to support enabling of 6000 and 1000 series
hardware. We add aggregation tables to rate scaling algorithm for improved
performance. There is also now an additional LED mode if users do not want
a blinking LED but just an LED reflecting RF state.

We include two fixes targeting 2.6.32: 12/13 removes sleeping code from a
spinlock section to prevent potential deadlock, 13/13 reduce significant
unnecessary noise when skb allocation fails in atomic context, this was
discussed in email thread linked to in commit message.

[PATCH 01/13] iwlwifi: Use RTS/CTS as the preferred protection mechanism for 6000 series
[PATCH 02/13] iwlwifi: allow user change protection mechanism for HT
[PATCH 03/13] iwlwifi: EEPROM version for 1000 and 6000 series
[PATCH 04/13] iwlwifi: use S_IRUGO and S_IWUSR in module parameters
[PATCH 05/13] iwlwifi: clean up rs_tx_status
[PATCH 06/13] iwlwifi: do not clear TX info flags when receiving BlockAckResponse
[PATCH 07/13] iwlwifi: add aggregation tables to the rate scaling algorithm
[PATCH 08/13] iwlwifi: send cmd to uCode to configure valid tx antenna
[PATCH 09/13] iwlwifi: update PCI Subsystem ID for 1000 series
[PATCH 10/13] iwlwifi: update PCI Subsystem ID for 6000 series
[PATCH 11/13] iwlwifi: add LED mode to support different LED behavior
[PATCH 12/13 v2.6.32 and w-t] iwlwifi: do not send sync command while holding spinlock
[PATCH 13/13 v2.6.32 and w-t] iwlwifi: reduce noise when skb allocation fails


Thank you

Reinette

