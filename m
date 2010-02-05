Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:36531 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444Ab0BENvT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 08:51:19 -0500
Message-ID: <4B6C223F.5070002@scram.de>
Date: Fri, 05 Feb 2010 14:50:55 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: gertjan@vanwingerde.net,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Subject: Status of http://patchwork.kernel.org/patch/62072/
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

does anybody know what's the deal with patch http://patchwork.kernel.org/patch/62072/ ?
On ath5k hardware (WGT634U running OpenWRT Kamikaze with current compat-wireless) this patch is 
still needed to avoid these headroom too small messages on WDS links (4addr frame format).

Thanks,
Jochen
