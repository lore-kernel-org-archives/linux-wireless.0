Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19321 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548AbYLKScm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:32:42 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi driver updates
Date: Thu, 11 Dec 2008 10:33:35 -0800
Message-Id: <1229020421-4823-1-git-send-email-reinette.chatre@intel.com> (sfid-20081211_193246_251570_31E07F43)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are mostly cleanup and reorganization patches except for one fix
(patch 2).

[PATCH 1/6] iwlwifi: use iwl_poll_direct_bit in EEPROM reading
[PATCH 2/6] iwlwifi: fix resume while txpower off
[PATCH 3/6] iwlwifi: remove unused clip_groups priv member
[PATCH 4/6] iwlwifi: remove includes of iwl-helpers.h where not needed
[PATCH 5/6] iwlwifi: remove 4965 from common uCode API structures
[PATCH 6/6] iwlwifi: add contact email to MODULE_AUTHOR


Thank you

Reinette

