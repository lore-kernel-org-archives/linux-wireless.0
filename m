Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:58278 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705Ab2G0QA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 12:00:28 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org
Subject: [PATCH 0/2] mac80211: Add transmit power control (TPC) support
Date: Fri, 27 Jul 2012 18:00:07 +0200
Message-Id: <1343404809-70329-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120727_180036_685576_468B8BD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds necessary stuctures, annotations, flags and 
documentation to support per TPC for data and ACK packets. Different 
hardware capabilities of the TPC tunebility can be specified. TPC per
data packet, per data-packets multi-retry-stage (mrr stage) and a
global ack power level are introduced. These are pre-requisits to any
TPC algorithm at mac80211 to control power levels and individual
drivers to tranform this into necessary actions of gain amplification.

Greetings Thomas

