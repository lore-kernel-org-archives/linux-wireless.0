Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:58363 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056AbXGIURi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 16:17:38 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 859208CAD8
	for <linux-wireless@vger.kernel.org>; Mon,  9 Jul 2007 22:17:30 +0200 (CEST)
Received: from meerkat.home.warmcat.com (unknown [192.168.0.242])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 32915103A7
	for <linux-wireless@vger.kernel.org>; Mon,  9 Jul 2007 20:18:49 +0000 (UTC)
Received: from meerkat.home.warmcat.com (localhost [127.0.0.1])
	by meerkat.home.warmcat.com (Postfix) with ESMTP id 065D918D24CC
	for <linux-wireless@vger.kernel.org>; Mon,  9 Jul 2007 21:17:35 +0100 (BST)
Message-ID: <469297DF.4000806@warmcat.com>
Date: Mon, 09 Jul 2007 21:17:35 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Permissions down /sys
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

Is 222 permissions on /sys/class/ieee80211/phy*/add_iface and
remove_iface really okay, or should it perhaps be 220?

--w--w--w- 1 root root    0 2007-07-09 21:11 add_iface
--w--w--w- 1 root root 4096 2007-07-09 21:12 remove_iface

-Andy
