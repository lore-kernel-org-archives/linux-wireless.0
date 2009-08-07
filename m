Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1415 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZHGWlw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:52 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/16] iwlwifi driver updates 07/08/2009
Date: Fri,  7 Aug 2009 15:41:36 -0700
Message-Id: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we re-enable the feature that enables users with multiple
iwlwifi devices in one system to be able to set debug flags per device. We
also complete the "fat" to "ht40" name change. This series contains a few
patches that introduce significant debug support via debugfs. A previous
feature that attempted to make ucode loading more reliable caused some
issues and we are reverting it in this batch. We include a few fixes and
cleanup to the thermal throttling code and some other general fixes. A new
feature introduced with this series is the support of dynamic power save
support. Unfortuantely power save support still has some issues and we have
to disable it until these have been resolved.

[PATCH 01/16] iwlwifi: re-introduce per device debugging
[PATCH 02/16] iwlwifi: name changed from "fat" to "ht40"
[PATCH 03/16] iwlwifi: new debugging feature for dumping data traffic
[PATCH 04/16] iwlwifi: Traffic type and counter for debugFs
[PATCH 05/16] iwlwifi: tx/rx queue pointer information
[PATCH 06/16] iwlwifi: uCode statistics notification counter
[PATCH 07/16] iwlwifi: Display sensitivity and chain noise information
[PATCH 08/16] iwlwifi: revert uCode Alive notification with timeout
[PATCH 09/16] iwlwifi: fix thermal throttling locking problem
[PATCH 10/16] iwlwifi: fix legacy thermal throttling power index
[PATCH 11/16] iwlwifi: handle the case when set power fail
[PATCH 12/16] iwlwifi: refactor some thermal throttle code
[PATCH 13/16] iwlwifi: fix missing EXPORT_SYMBOL
[PATCH 14/16] iwlwifi: display correct critical temperature infomation
[PATCH 15/16] iwlwifi: automatically adjust sleep level
[PATCH 16/16] iwlwifi: disable powersave mode


Thank you

Reinette

