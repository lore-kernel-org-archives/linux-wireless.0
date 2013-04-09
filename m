Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:51610 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761894Ab3DIPEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 11:04:41 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH 0/11] rt2800: cleanup rfcsr init procedures
Date: Tue,  9 Apr 2013 17:05:19 +0200
Message-Id: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> (sfid-20130409_170444_986077_C686199D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set move code from common RFCSR init procedure to individual
chipset procedures. That make code easier to maintain and modify.

 rt2800lib.c |  548 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 280 insertions(+), 268 deletions(-)

