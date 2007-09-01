Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:56199 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXIAEeQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:34:16 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 2AB1E618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:34:15 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 00/35] Update at76_usb to the start of mac80211 port
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:34:14 -0400
Message-ID: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This brings at76_usb to the point where Kalle Valo started mac80211
conversion.

Further patches that bring the driver to version 0.16 will be submitted
once it's clear how the conflicts with Kalle's changes can be resolved
(i.e. which patch goes first and which must be rebased).

-- 
Regards,
Pavel Roskin
