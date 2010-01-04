Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52755 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab0ADUxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:53:33 -0500
Date: Mon, 4 Jan 2010 21:53:32 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 00/14] more mwl8k updates
Message-ID: <20100104205332.GZ1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series (against current wireless-testing), some more cleanup,
and initial 11n STA support for 88w8363 (2x3) and for 88w8366 (3x3).

Coming soon to a mwl8k theater near you are AP support, multi-BSS
support, AMPDU transmit, hardware crypto and (non-DFS) 5GHz channels.

Feedback appreciated!
