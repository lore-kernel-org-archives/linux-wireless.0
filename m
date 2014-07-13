Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49792 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaGMKaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 06:30:15 -0400
Message-ID: <53C25FB1.7030802@openwrt.org> (sfid-20140713_123024_552715_47D20ADA)
Date: Sun, 13 Jul 2014 12:30:09 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	ath9k-devel@lists.ath9k.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFCv2 09/10] ath9k: disable dynack algorithm when
 coverage class is set
References: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com> <1405246704-7489-10-git-send-email-lorenzo.bianconi83@gmail.com>
In-Reply-To: <1405246704-7489-10-git-send-email-lorenzo.bianconi83@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-07-13 12:18, Lorenzo Bianconi wrote:
> Disable ack timeout estimation algorithm if the coverage class has been
> configured
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
I think this is broken, since it doesn't allow you to re-enable dynack
through the same way as it was disabled.
I would recommend adding an 'auto' value for coverage class.

- Felix
