Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:56587 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933083AbYBHFdG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 00:33:06 -0500
Date: Fri, 8 Feb 2008 06:30:51 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [PATCH 0/4] b43legacy fixes
Message-ID: <20080208063051.68ffbc3f@morte> (sfid-20080208_053338_971270_DE7C03A4)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches are mostly ports from b43. Please note that patch 2/4 is
merged with all fixes subsequently posted for the original patch.

It would be fine to have at least patch 4/4 into 2.6.25, but it's not so 
relevant (only hits users who force DMA mode over PIO with 64 bits processors
running a 32 bit kernel with more than 1G of memory - no crash happens though).

John, please tell me if you need me to port this over any other branch.
Thanks.


--
Ciao
Stefano
