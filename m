Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50980 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbZESWBB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 18:01:01 -0400
Subject: iwlwifi 5000 uCode available
From: reinette chatre <reinette.chatre@intel.com>
To: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Tue, 19 May 2009 15:07:41 -0700
Message-Id: <1242770861.32358.839.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Version 8.24.2.12 of uCode for Intel Wireless WiFi Link 5100AGN,
5300AGN, and 5350AGN  is now available for download from
http://intellinuxwireless.org/?n=Downloads

To use this firmware your driver will need to know about the API change.
This patch has just been sent upstream [1].

This ucode includes the fix for the "wrong command queue" problem that
is tracked in [2].

Changes:
     1. Move TXPOWER_DBM from 0x98 to 0x95 
     2. Add Baseband Filter calibration 
     3. Improve other built-in radio calibrations, fix execution order 
     4. Fix "wrong queue" bug due to occasional command serial number
        management 
     5. More reliable scans (including full active dwell time after
        auto-switch from passive to active scan) 
     6. More reliable NULL packet Tx (scan-related) 
     7. More robust RF-kill support 
     8. Tune up some hardware timings 
     9. MAC access wakeup fix 
    10. Better TSF calculation 
    11. Minor improvements to debugging 
    12. Sync with bug fixes from factory

Reinette

[1] http://marc.info/?l=linux-wireless&m=124276980711614&w=2
[2] http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1946



