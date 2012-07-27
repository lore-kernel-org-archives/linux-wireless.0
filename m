Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57947 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979Ab2G0JfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 05:35:25 -0400
Message-ID: <501260DB.1020606@net.t-labs.tu-berlin.de> (sfid-20120727_113528_900249_C53577C9)
Date: Fri, 27 Jul 2012 11:35:23 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arik Nemtsov <arik@wizery.com>, nbd@openwrt.org, coelho@ti.com,
	brcm80211-dev-list@broadcom.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	ilw@linux.intel.com, ath9k-devel@lists.ath9k.org,
	b43-dev@lists.infradead.org, chunkeey@googlemail.com,
	dsd@gentoo.org, buytenh@wantstofly.org
Subject: Re: [PATCH v6] mac80211: Remove control.sta from struct ieee80211_tx_info
 and restructure tx-path
References: <1343318961-46933-1-git-send-email-thomas@net.t-labs.tu-berlin.de>  <1343319453.4477.2.camel@jlt3.sipsolutions.net>  <1343319579.4477.3.camel@jlt3.sipsolutions.net>  <501170F2.3050300@net.t-labs.tu-berlin.de>  <CA+XVXfegYYwc=esyZmJHu1tEqQKcq+h+MnSyp9dXiiwqroG3tw@mail.gmail.com>  <CA+XVXfcrb9=XQauvbPzw2t_jMoQisrh5aSB1qwpLxXsKJKy2Yg@mail.gmail.com>  <CA+XVXfe1uomu4XYD33==bFFozbo9k4mkqC1PE1ORnvVN_1PeTg@mail.gmail.com>  <5011A250.4010500@net.t-labs.tu-berlin.de> <1343374017.4449.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343374017.4449.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Johannes Berg schrieb:


> When you do, please remove the last two hunks from your patch that are
> spurious indentation changes in tx.c


When Ariks two TI driver patches make it in your tree I will clean up
this two hunks... no prob.

Greetings Thomas
