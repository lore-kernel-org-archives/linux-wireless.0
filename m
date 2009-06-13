Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:42556 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbZFMCGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 22:06:53 -0400
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-wireless@vger.kernel.org
Subject: AR2424 speed issue.
Date: Fri, 12 Jun 2009 20:06:55 -0600
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200906122006.55492.tfjellstrom@shaw.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just got a new laptop with an Atheros 2424 based wifi card (lspci says 
AR242x, but the pci device id is: 0035).

While it seems to be stable, it is quite slow for 802.11g. The maximum speed I 
can get out of the ath5k driver is the speed it auto connects at: 36Mb/s. If I 
force it to anything higher, nothing can get through (the actual connection 
seems to stay up till some form of very long time out happens).

I just tried the madwifi drivers on madwifi's website (latest trunk snapshot, 
and svn trunk itself) and It auto connects at 18Mb/s. If I up the rate to 
54Mb/s the connection stays up, but it doesn't really seem to be transferring 
any faster.

For comparison's sake I tried it out in Windows 7. It auto connects at 54Mb/s 
and can stream 1080p h264 without stuttering. In linux however, many SD or 
lower res Xvid won't play without stuttering. 720p and 1080p are unwatchable.

What can be done about this? Is there some setting I'm overlooking? Its quite 
annoying to have to reboot into windows to watch some videos.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
