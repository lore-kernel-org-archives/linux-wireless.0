Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:12657 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758176AbZJBUts (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/13] iwlwifi driver updates 10/2/2009
Date: Fri,  2 Oct 2009 13:43:54 -0700
Message-Id: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we include two fixes targeting 2.6.32:
1/13 is needed to parse OTP data correctly, without this devices with valid
OTP data may be unable to work - this fix also targets 2.6.31
2/13 fixes the EEPROM offsets used for enhanced TX power data

This series introduces, thanks to Johannes, device tracing utilizing the
ftrace framework.

[PATCH 01/13 v2.6.31, v2.6.32 and w-t] iwlwifi: incorrect method used for finding valid OTP blocks
[PATCH 02/13 v2.6.32 and w-t] iwlwifi: fix EEPROM enhance tx power offset
[PATCH 03/13] iwlwifi: fix compile warning
[PATCH 04/13] iwlwifi: reliable entering of critical temperature state
[PATCH 05/13] iwlwifi: change valid EEPROM version for 1000 series
[PATCH 06/13] iwlwifi: clear the translate table area
[PATCH 07/13] iwlwifi: set default aggregation frame count limit to 31
[PATCH 08/13] iwlwifi: device tracing
[PATCH 09/13] iwlwifi: LED cleanup
[PATCH 10/13] iwlwifi/iwl3945 : unify apm stop operation
[PATCH 11/13] iwlwifi: replace iwl_poll_direct_bit with iwl_poll_bit for CSR access
[PATCH 12/13] iwlwifi: validate the signature for EEPROM and OTP
[PATCH 13/13] iwlagn: fix compile warning in iwl5000_gain_computation

Thank you

Reinette

