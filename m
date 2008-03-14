Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45596 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbYCNRsl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2008 13:48:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/5] iwlwifi driver updates
Date: Fri, 14 Mar 2008 10:38:44 -0700
Message-Id: <1205516329-22172-1-git-send-email-reinette.chatre@intel.com> (sfid-20080314_174956_513337_D11617ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains cleanup and reorganization code.

[PATCH 1/5] iwlwifi: remove macros containing offsets from eeprom struct
[PATCH 2/5] iwlwifi: Re-ordering probe flow (4965)
[PATCH 3/5] iwlwifi: Packing all 4965 parameters
[PATCH 4/5] iwlwifi: Probe Flow - Performing allocation in a separate function
[PATCH 5/5] iwlwifi: Probe Flow - Extracting hw and priv init

Thanks

Reinette
