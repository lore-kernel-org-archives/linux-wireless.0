Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:37780 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076AbbBZOkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 09:40:31 -0500
Date: Thu, 26 Feb 2015 15:40:28 +0100
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: poma <pomidorabelisima@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>, kubakici@wp.pl,
	"John W. Linville" <linville@tuxdriver.com>,
	Etna <etna@openmailbox.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: MediaTek WiFi hardware support in upstream kernel
Message-ID: <20150226154028.380b96f2@north> (sfid-20150226_154034_312344_BDB44BEF)
In-Reply-To: <54EF261E.4040109@gmail.com>
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
	<20150206182915.7467bac7@north>
	<54EF261E.4040109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 26 Feb 2015 14:56:46 +0100, poma wrote:
> On 06.02.2015 18:29, Jakub Kiciński wrote:
> > Hello everyone!
> > 
> > I put together a mac80211 driver for Mediatek MT7601U.  It's partially
> > based on Felix's mt76, but I'm not sure if it will make sense to merge
> > the two together.  MT7601U is a pretty old 1x1 bgn chip for USB dongles
> > and mt76 now only supports the latest and greatest ac APs.
> > 
> > I'm testing STA functionality right now and it seems to be working ok.
> > The code is very much a work in progress but if anyone is interested you
> > can get it here:
> > 
> > https://github.com/kuba-moo/mt7601u
> > 
> > Cheers,
> > kuba
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> How many mt7601u module editions exists there? :)
> - vendor's
> - vendor's patched (how many forms of the same)
> - your reinvented
> - the one on which pán Gruszka allegedly works?
> - any more?

I assume you mean to ask how many different drivers are there.
There is the vendor 3.0.0.4 STA driver which only has client
functionality.  Many patched versions of this driver exist on GitHub.
There is also an older version of vendor driver which can work as an
AP.  My mac80211-based driver is the only non-vendor version I'm aware
of.
