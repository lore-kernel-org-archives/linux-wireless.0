Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:36829 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab3CARhn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 12:37:43 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 0/7] mac80211: improve and consolidate minstrel rate control 
Date: Fri,  1 Mar 2013 18:37:29 +0100
Message-Id: <1362159456-39448-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130301_183748_203358_A3BE35F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series merges functions, macros and sampling improvements from
minstrel_ht into minstrel. It adds several improvements to the rate control.  

Thomas

