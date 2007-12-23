Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:37776 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752661AbXLWDNL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 22:13:11 -0500
Date: Sun, 23 Dec 2007 04:10:57 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Only select allowed TX and RX antennas
Message-ID: <20071223041057.074286bd@morte> (sfid-20071223_031316_148891_AA46B023)
In-Reply-To: <200712222154.20424.mb@bu3sch.de>
References: <200712222154.20424.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 22 Dec 2007 21:54:20 +0100
Michael Buesch <mb@bu3sch.de> wrote:

> This fixes antenna selection in b43. It adds a sanity check
> for the antenna numbers we get from mac80211.

Just FYI. I'm going to port this patch to b43legacy, as soon as I figure
out exactly the differences between v3 and v4 firmware devices here.


-- 
Ciao
Stefano
