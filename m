Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33436 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbbBZN4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 08:56:51 -0500
Received: by wghb13 with SMTP id b13so11013594wgh.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2015 05:56:50 -0800 (PST)
Message-ID: <54EF261E.4040109@gmail.com> (sfid-20150226_145657_825011_F4F9FAFE)
Date: Thu, 26 Feb 2015 14:56:46 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?SmFrdWIgS2ljacWEc2tp?= <moorray3@wp.pl>,
	linux-wireless@vger.kernel.org
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>, kubakici@wp.pl,
	"John W. Linville" <linville@tuxdriver.com>,
	Etna <etna@openmailbox.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: MediaTek WiFi hardware support in upstream kernel
References: <544DB5A8.7090405@openmailbox.org>	<20141027152026.GB19976@tuxdriver.com>	<544E8CB4.3000607@rempel-privat.de>	<20141028134608.GA26283@tuxdriver.com>	<544FA303.5060303@broadcom.com>	<544FA627.3000004@rempel-privat.de>	<5450BEB2.60208@openwrt.org>	<5461F937.9060004@rempel-privat.de>	<5463CB6C.3030204@openwrt.org>	<5463D28F.9080106@lwfinger.net> <20150206182915.7467bac7@north>
In-Reply-To: <20150206182915.7467bac7@north>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06.02.2015 18:29, Jakub Kiciński wrote:
> Hello everyone!
> 
> I put together a mac80211 driver for Mediatek MT7601U.  It's partially
> based on Felix's mt76, but I'm not sure if it will make sense to merge
> the two together.  MT7601U is a pretty old 1x1 bgn chip for USB dongles
> and mt76 now only supports the latest and greatest ac APs.
> 
> I'm testing STA functionality right now and it seems to be working ok.
> The code is very much a work in progress but if anyone is interested you
> can get it here:
> 
> https://github.com/kuba-moo/mt7601u
> 
> Cheers,
> kuba
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

How many mt7601u module editions exists there? :)
- vendor's
- vendor's patched (how many forms of the same)
- your reinvented
- the one on which pán Gruszka allegedly works?
- any more?


