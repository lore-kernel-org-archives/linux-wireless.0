Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm3.bullet.mail.ukl.yahoo.com ([217.146.182.224]:25542 "HELO
	nm3.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751526Ab1LDHsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Dec 2011 02:48:00 -0500
From: Marek Lindner <lindner_marek@yahoo.de>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 3.2] ath9k: fix check for antenna diversity support
Date: Sun, 4 Dec 2011 15:47:51 +0800
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
References: <1322984334-62659-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1322984334-62659-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201112041547.51828.lindner_marek@yahoo.de> (sfid-20111204_084838_656191_BB034CB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, December 04, 2011 15:38:54 Felix Fietkau wrote:
> fixes a regression on single-stream chips introduced in
> commit 43c3528430bd29f5e52438cad7cf7c0c62bf4583
> "ath9k: implement .get_antenna and .set_antenna"
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks for adding me[1] as "Reported-by" ..

Regards,
Marek

[1] http://article.gmane.org/gmane.comp.embedded.openwrt.devel/11952
