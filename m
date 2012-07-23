Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12338 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2GWIzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 04:55:53 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20493.4431.718627.845408@gargle.gargle.HOWL> (sfid-20120723_105557_640089_340DCDCE)
Date: Mon, 23 Jul 2012 14:24:39 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<linville@tuxdriver.com>, <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath: Remove EEPROM dump functions
In-Reply-To: <500D106E.50500@openwrt.org>
References: <20492.53472.318382.889445@gargle.gargle.HOWL>
	<500D106E.50500@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I think we should keep this code until we have a proper user space
> replacement, I've been using it for debugging a number of times.
> The qca-swiss-army-knife patch that you posted is missing quite a bit of
> stuff (AR9003 support, HTC support).

Ok.

I'll add AR9003 support to the tool. HTC/USB support can wait ?

Sujith
