Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40191 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980AbYLKSxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:53:15 -0500
Subject: new iwlwifi 4965 uCode available
From: reinette chatre <reinette.chatre@intel.com>
To: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Thu, 11 Dec 2008 10:54:19 -0800
Message-Id: <1229021659.18730.231.camel@rc-desk> (sfid-20081211_195323_067898_14A6F70F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Version 228.57.2.23 of the 4965 uCode is now available for download from
http://intellinuxwireless.org/?n=Downloads . 

Changes:
- Allow full active scan dwell time after auto-switch from passive to
active.
- Properly decrement sequence number to avoid "wrong command queue"
error, which is tracked in
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703 and
http://bugzilla.kernel.org/show_bug.cgi?id=11983


Reinette


