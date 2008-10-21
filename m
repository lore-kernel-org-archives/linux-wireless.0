Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:50926 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751878AbYJUS05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 14:26:57 -0400
Subject: New iwlwifi 3945 uCode available
From: reinette chatre <reinette.chatre@linux.intel.com>
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 21 Oct 2008 11:27:13 -0700
Message-Id: <1224613633.10863.43.camel@rc-desk> (sfid-20081021_202700_149655_8ACA52AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two new versions of 3945 uCode is now available for download from
http://intellinuxwireless.org/?n=Downloads. Two versions are available
as we have updated the API version of the uCode and included pending
fixes in both API versions.

Version 15.28.1.8 supports API v1 and can be used with most current 3945
drivers. Version 15.28.2.8 (API v2) is required when you start using the
latest 3945 driver from wireless-testing at the time it includes the
patch "iwl3945 : Fix a-band association for passive channels".

Changes:

Version 15.28.1.8
- Allow full active dwell time after scan auto-switches from passive to
active scan
- Allow direct probes on passive-scan channels (after auto-switch)
- Expand coverage in Event Log

Version 15.28.2.8
- Allow full active dwell time after scan auto-switches from passive to
active scan
- Allow direct probes on passive-scan channels (after auto-switch)
- Expand coverage in Event Log

Reinette


