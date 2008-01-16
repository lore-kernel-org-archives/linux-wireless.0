Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39542 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYAPSlI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 13:41:08 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
Subject: [RFC PATCH 0/12 v2] mac80211/iwlwifi: A-MPDU Tx support
Date: Wed, 16 Jan 2008 20:40:48 +0200
Message-Id: <1200508860699-git-send-email-ron.rindjunsky@intel.com> (sfid-20080116_184112_252588_31AEB934)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This RFC contains fixes to all comments made for first series of RFC, and adds
the ability to handle delBA as initiator, and a first activation of the
A-MPDU Tx (from rate scaling)


