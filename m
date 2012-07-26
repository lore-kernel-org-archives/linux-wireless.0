Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:56821 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040Ab2GZJ1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 05:27:43 -0400
Message-ID: <50110D8C.3010705@net.t-labs.tu-berlin.de> (sfid-20120726_112746_821500_B48A303E)
Date: Thu, 26 Jul 2012 11:27:40 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luciano Coelho <coelho@ti.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	ath5k-devel@venema.h4ckr.net, ilw@linux.intel.com,
	users@rt2x00.serialmonkey.com, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com, chunkeey@googlemail.com,
	buytenh@wantstofly.org, dsd@gentoo.org, nbd@openwrt.org
Subject: Re: [PATCH v5] mac80211: Remove control.sta from struct ieee80211_tx_info
 and restructure tx-path
References: <1343161108-6941-1-git-send-email-thomas@net.t-labs.tu-berlin.de>  (sfid-20120724_221843_511093_701FFAF2) <1343208990.4463.25.camel@jlt3.sipsolutions.net>  (sfid-20120725_113644_599580_8AC4476F) <1343220625.4463.31.camel@jlt3.sipsolutions.net>  <500FEDDD.206@net.t-labs.tu-berlin.de>  <1343244302.3750.44.camel@cumari.coelho.fi> <1343283856.4611.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343283856.4611.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On my Linux box I applied and compiled the current v5 version of the
patch successfully. On top of the following freshly checked out git
repos I put the remove-sta patch:

(1)
url =
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

last commit 80f3bc801e351ee7f71de67a3939dd7628cdb195


(2)
url = git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git

last commit e4cbd6542efdab97ed6d38e706b7cac51c68ced7

Did you had anything different when you tried to compile it as I can not
reproduce the compile error here on my side.

Greetings Thomas
