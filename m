Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42151 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbXJAKXD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2007 06:23:03 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IcIQB-00031f-2B
	for linux-wireless@vger.kernel.org; Mon, 01 Oct 2007 10:22:39 +0000
Received: from 80.169.182.16 ([80.169.182.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2007 10:22:39 +0000
Received: from marcus by 80.169.182.16 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2007 10:22:39 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: rt2500pci 2.0.9 not working
Date: Mon, 01 Oct 2007 12:18:31 +0200
Message-ID: <fdqhn4$qab$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just tried the rt2500pci driver version 2.0.9 from the wireless-2.6 tree.
It does not work. There is no connection, and "iwlist scan" produces no
scan results.

I'm successfully using version 2.0.7 from wireless-dev (2.6.23-rc3 i386) on
this LG laptop.

Marcus


