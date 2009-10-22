Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49154 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbZJVShI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:08 -0400
Date: Thu, 22 Oct 2009 20:19:16 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [RFC,PATCH 00/28] mwl8k updates, initial AP firmware support
Message-ID: <20091022181916.GB1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set includes an initial cut at adding support to mwl8k
for AP chips and firmware images.  AP firmware images present a
slightly different command set than STA firmware images do, and this
patch set adds support for those AP commands necessary to initialise
the firmware and allow packet reception.

Note that AP/STA interface creation on AP firmware images is not
supported yet, this will be added in another set of patches.

(All the code to allow using mwl8k in AP mode exists and works, with
11n/AMPDU/hw crypto support, etc., it just needs to be cleaned up a
bit more and chopped up into logical chunks suitable for submission.)

Comments appreciated!
