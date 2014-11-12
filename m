Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39399 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaKLVEs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 16:04:48 -0500
Message-ID: <5463CB6C.3030204@openwrt.org> (sfid-20141112_220451_588182_0D82C04E)
Date: Wed, 12 Nov 2014 22:04:44 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Etna <etna@openmailbox.org>, linux-wireless@vger.kernel.org
Subject: Re: MediaTek WiFi hardware support in upstream kernel
References: <544DB5A8.7090405@openmailbox.org> <20141027152026.GB19976@tuxdriver.com> <544E8CB4.3000607@rempel-privat.de> <20141028134608.GA26283@tuxdriver.com> <544FA303.5060303@broadcom.com> <544FA627.3000004@rempel-privat.de> <5450BEB2.60208@openwrt.org> <5461F937.9060004@rempel-privat.de>
In-Reply-To: <5461F937.9060004@rempel-privat.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-11-11 12:55, Oleksij Rempel wrote:
> Am 29.10.2014 um 11:17 schrieb Felix Fietkau:
>> Hi Hackers,
>> 
>> Just a quick heads up:
>> I'm working on a new driver for MT7662E/MT7612E, written from scratch.
>> It is already able to bring up the firmware, init the MAC and do basic
>> TX/RX DMA communication with the firmware.
>> I've decided to not integrate it with rt2x00, because I want to avoid
>> dealing with the the unnecessarily convoluted abstractions and legacy
>> code in there. I believe the result will be simpler and easier to
>> maintain as a new driver.
>> As soon as the basic structure is in place, I will put it on a public
>> git tree and post a link here.
>> 
>> - Felix
> 
> Which chip would you suggest for starting?
The chips I'm working with are both MT7662 and MT7612. My driver already
works as a simple AP or station in 802.11n mode with some limited
aggregation support. I'm getting around 45-50 Mbit/s TCP throughput on
HT20 with iperf. I will post code soon, stay tuned!

- Felix
