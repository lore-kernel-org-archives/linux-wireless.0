Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43962 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaA3Gzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 01:55:41 -0500
Message-ID: <52E9F757.3040306@openwrt.org> (sfid-20140130_075602_454801_F36C1CCB)
Date: Thu, 30 Jan 2014 07:55:19 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix uninitialized variable in ath9k_has_tx_pending()
References: <1390733601-11244-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1390733601-11244-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-01-26 11:53, Geert Uytterhoeven wrote:
> drivers/net/wireless/ath/ath9k/main.c: In function ‘ath9k_has_tx_pending’:
> drivers/net/wireless/ath/ath9k/main.c:1869: warning: ‘npend’ may be used uninitialized in this function
> 
> Introduced by commit 10e2318103f5941aa70c318afe34bc41f1b98529 ("ath9k:
> optimize ath9k_flush").
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Felix Fietkau <nbd@openwrt.org>
