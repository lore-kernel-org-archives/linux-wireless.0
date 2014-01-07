Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62690 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaAGJ1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 04:27:53 -0500
Message-ID: <52CBC88C.90706@lri.fr> (sfid-20140107_102757_375612_D28F0EB6)
Date: Tue, 07 Jan 2014 10:27:40 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, openwrt-devel@lists.openwrt.org
Subject: Re: OpenWrt kernel_menuconfig issue?
References: <20140106140103.GA24241@rhlx01.hs-esslingen.de> <1389017367.5891.13.camel@jlt4.sipsolutions.net> <20140106191808.GA7179@rhlx01.hs-esslingen.de>
In-Reply-To: <20140106191808.GA7179@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/01/2014 20:18, Andreas Mohr wrote:
> Can someone else confirm and/or elaborate on this improper visibility problem
> which seems to be specific to OpenWrt's kernel configuration management?
> (which does do certain config things in a rather custom way, I might add)

This patch explains it all:

https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-3.12/255-lib80211_kconfig_hacks.patch
