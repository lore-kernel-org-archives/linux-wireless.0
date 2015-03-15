Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35931 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbbCOI6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 04:58:46 -0400
MIME-Version: 1.0
In-Reply-To: <55030C42.6020206@armadeus.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
	<55030C42.6020206@armadeus.com>
Date: Sun, 15 Mar 2015 10:58:45 +0200
Message-ID: <CAB3XZEc0FOayfmrWvD-aq0Ez987G4JFkvHxO-ttF48z_F=_9Vg@mail.gmail.com> (sfid-20150315_095852_499847_918DD2F8)
Subject: Re: [PATCH v6 0/6] wlcore: add device-tree support
From: Eliad Peller <eliad@wizery.com>
To: =?UTF-8?Q?S=C3=A9bastien_Szymanski?=
	<sebastien.szymanski@armadeus.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	=?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
	Kumar Gala <galak@codeaurora.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Julien Boibessot <julien.boibessot@armadeus.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Sébastien,

On Fri, Mar 13, 2015 at 6:11 PM, Sébastien Szymanski
<sebastien.szymanski@armadeus.com> wrote:
> Hello,
>
> On 03/12/2015 01:09 PM, Eliad Peller wrote:
>>
>> NOTE: all the platform patches were compile-tested
>> only. I'm looking for some wl12xx card (that i should
>> have somewhere) to test the wl12xx changes (wrt. clocks),
>> but haven't found it yet.
>>
>
> I have tested this series on a APF6 board, i.MX6 based board with a
> Jorjin WG7311-0A Wifi/BT module which is based on the wl1271l.
>
> It works. I was able to power up the wlan0 interface and ping google.
>
thanks for testing it!

Eliad.
