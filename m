Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36304 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab2EZS15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 14:27:57 -0400
Message-ID: <4FC120A3.3020307@openwrt.org> (sfid-20120526_202800_666716_4C54719B)
Date: Sat, 26 May 2012 20:27:47 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Joe Semler <josef.semler@gmail.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL> <7759D07D-C2C8-48D8-8F44-687C7E85D188@gmail.com> <20416.35246.76971.129331@gargle.gargle.HOWL> <CAPsaeQPxh0Yd+GT3HbReAAtoPhKF2c3kOzgOPL6xK7NC=8J4qA@mail.gmail.com> <4FC0CE2B.9060005@openwrt.org> <9532BE30-26F1-42CF-9300-C25585B29300@gmail.com>
In-Reply-To: <9532BE30-26F1-42CF-9300-C25585B29300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-05-26 7:15 PM, Joe Semler wrote:
> Hi Felix,
> 
> 
> Am 26.05.2012 um 14:35 schrieb Felix Fietkau <nbd@openwrt.org>:
> 
>>> 
>>> 
>>> OK, tnx Sujith, but that brings me to my next question acc. 2x2 or 3x3
>>> on OpenWRT-based devices like NanoStation M or AirBridge M.
>>> Up to now only 1x2 or 1x3 was possible on this devices. Do we have
>>> changings there too?
>> Why do you think that only 1x2 or 1x3 was possible on these devices? 2x2
>> and 3x3 has been working just fine for a long time now, and it's enabled
>> by default where supported by the hardware
> Pickend this Info from The List that devices with openwrt are just
> transmitting at 1 stream but rec. at both. How can I change the
> settings? Also with uci or only with the iw-commands?
You don't need to change anything, just use the defaults.
I have no idea what post from the list you're referring to, but here's a
piece of advice: It's not unheard of that sometimes people put wrong
things on the internet :)

- Felix
