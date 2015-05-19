Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38794 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbbESBDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 21:03:37 -0400
Received: by wichy4 with SMTP id hy4so3124456wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 18:03:36 -0700 (PDT)
Message-ID: <555A8BE5.5020102@gmail.com> (sfid-20150519_030448_255749_E83E87BC)
Date: Tue, 19 May 2015 03:03:33 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?SmFrdWIgS2ljacWEc2tp?= <moorray3@wp.pl>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>, kubakici@wp.pl,
	"John W. Linville" <linville@tuxdriver.com>,
	Etna <etna@openmailbox.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: MediaTek WiFi hardware support in upstream kernel
References: <544DB5A8.7090405@openmailbox.org>	<20141027152026.GB19976@tuxdriver.com>	<544E8CB4.3000607@rempel-privat.de>	<20141028134608.GA26283@tuxdriver.com>	<544FA303.5060303@broadcom.com>	<544FA627.3000004@rempel-privat.de>	<5450BEB2.60208@openwrt.org>	<5461F937.9060004@rempel-privat.de>	<5463CB6C.3030204@openwrt.org>	<5463D28F.9080106@lwfinger.net>	<20150206182915.7467bac7@north>	<54EF261E.4040109@gmail.com> <20150226154028.380b96f2@north> <55592C54.6010204@gmail.com>
In-Reply-To: <55592C54.6010204@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


kernel 4.0.4 - no more:
WARNING: CPU: x PID: 0 at kernel/softirq.c:150 __local_bh_enable_ip+0x72/0xa0()

One more detail - at least for this MT7601U device, USB extension cable must be high quality.


