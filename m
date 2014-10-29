Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42280 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbaJ2KR1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 06:17:27 -0400
Message-ID: <5450BEB2.60208@openwrt.org> (sfid-20141029_111731_539525_9D763373)
Date: Wed, 29 Oct 2014 11:17:22 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Etna <etna@openmailbox.org>, linux-wireless@vger.kernel.org
Subject: Re: MediaTek WiFi hardware support in upstream kernel
References: <544DB5A8.7090405@openmailbox.org> <20141027152026.GB19976@tuxdriver.com> <544E8CB4.3000607@rempel-privat.de> <20141028134608.GA26283@tuxdriver.com> <544FA303.5060303@broadcom.com> <544FA627.3000004@rempel-privat.de>
In-Reply-To: <544FA627.3000004@rempel-privat.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hackers,

Just a quick heads up:
I'm working on a new driver for MT7662E/MT7612E, written from scratch.
It is already able to bring up the firmware, init the MAC and do basic
TX/RX DMA communication with the firmware.
I've decided to not integrate it with rt2x00, because I want to avoid
dealing with the the unnecessarily convoluted abstractions and legacy
code in there. I believe the result will be simpler and easier to
maintain as a new driver.
As soon as the basic structure is in place, I will put it on a public
git tree and post a link here.

- Felix
