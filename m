Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:49932 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752391Ab1H1Twl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 15:52:41 -0400
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] net/mac80211/debugfs: Convert to kstrou8_from_user
Date: Sun, 28 Aug 2011 21:52:31 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1307478974-32727-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1307478974-32727-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201108282152.32180.PeterHuewe@gmx.de> (sfid-20110828_215259_191676_04BBCF65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 07 Juni 2011, 22:36:14 schrieb Peter Huewe:
> This patch replaces the code for getting an number from a
> userspace buffer by a simple call to kstrou8_from_user.
> This makes it easier to read and less error prone.
> 
> Since the old buffer was only 10 bytes long and the value is masked by a
> nibble-mask anyway, we don't need to use kstrtoul but rather kstrtou8.
> 
> Kernel Version: v3.0-rc2
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Any updates on this one?
Still applies to the latest linus' tree

Thanks,
Peter
