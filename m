Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33812 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab2EXMhI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 08:37:08 -0400
Message-ID: <4FBE2B72.2050408@openwrt.org> (sfid-20120524_143713_872098_1058FE39)
Date: Thu, 24 May 2012 14:37:06 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH v3] ath5k: add possible wiphy interface combinations
References: <1334623167-64479-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1334623167-64479-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-17 2:39 AM, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
John, please merge this into 3.5, otherwise people will be unable to use
multiple interfaces with ath5k anymore because of the commit
"cfg80211: enforce lack of interface combinations"

- Felix
