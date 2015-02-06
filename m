Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:47415 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675AbbBFR30 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 12:29:26 -0500
Date: Fri, 6 Feb 2015 18:29:15 +0100
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>, kubakici@wp.pl,
	"John W. Linville" <linville@tuxdriver.com>,
	Etna <etna@openmailbox.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: MediaTek WiFi hardware support in upstream kernel
Message-ID: <20150206182915.7467bac7@north> (sfid-20150206_182930_229327_A516ABA4)
In-Reply-To: <5463D28F.9080106@lwfinger.net>
References: <544DB5A8.7090405@openmailbox.org>
	<20141027152026.GB19976@tuxdriver.com>
	<544E8CB4.3000607@rempel-privat.de>
	<20141028134608.GA26283@tuxdriver.com>
	<544FA303.5060303@broadcom.com>
	<544FA627.3000004@rempel-privat.de>
	<5450BEB2.60208@openwrt.org>
	<5461F937.9060004@rempel-privat.de>
	<5463CB6C.3030204@openwrt.org>
	<5463D28F.9080106@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone!

I put together a mac80211 driver for Mediatek MT7601U.  It's partially
based on Felix's mt76, but I'm not sure if it will make sense to merge
the two together.  MT7601U is a pretty old 1x1 bgn chip for USB dongles
and mt76 now only supports the latest and greatest ac APs.

I'm testing STA functionality right now and it seems to be working ok.
The code is very much a work in progress but if anyone is interested you
can get it here:

https://github.com/kuba-moo/mt7601u

Cheers,
kuba
