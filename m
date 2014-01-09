Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41216 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaAIN5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 08:57:11 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21198.43395.235654.597422@gargle.gargle.HOWL> (sfid-20140109_145716_173813_D596405D)
Date: Thu, 9 Jan 2014 19:22:03 +0530
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
In-Reply-To: <52CEA5A3.2040308@neratec.com>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
	<1384665016-12022-5-git-send-email-sujith@msujith.org>
	<52CE934D.1020400@neratec.com>
	<21198.40916.260973.48444@gargle.gargle.HOWL>
	<52CEA5A3.2040308@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik wrote:
> AR9590 running on powerpc with latest openwrt i.e. 
> compat-wireless-2013-11-05 backported with
> your changes for split pci/soc IQ calibration.
> 
> I could try to reproduce it on my host with latest wireless testing if 
> you think

It would also be good to know if this is a regression from this patch,
so checking an older version of the driver without this patch would help.

Sujith
