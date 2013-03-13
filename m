Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:55260 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186Ab3CMKEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 06:04:05 -0400
Message-ID: <1363169039.3137.186.camel@x61.thuisdomein> (sfid-20130313_110409_418081_4BF045CE)
Subject: Re: rt2x00: Kconfig symbols RALINK_RT288X and RALINK_RT305X
From: Paul Bolle <pebolle@tiscali.nl>
To: Jonas Gorski <jogo@openwrt.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	John Crispin <blogic@openwrt.org>
Date: Wed, 13 Mar 2013 11:03:59 +0100
In-Reply-To: <CAOiHx=n4a26z=PS02E2KjD2Y3Pp0P0x-5Ns6WRc-WScNF=EO_Q@mail.gmail.com>
References: <1363165170.3137.182.camel@x61.thuisdomein>
	 <CAOiHx=n4a26z=PS02E2KjD2Y3Pp0P0x-5Ns6WRc-WScNF=EO_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-13 at 10:51 +0100, Jonas Gorski wrote:
> On 13 March 2013 09:59, Paul Bolle <pebolle@tiscali.nl> wrote:
> > 3) What is the current status of the (out of tree) code that adds
> > RALINK_RT288X and RALINK_RT305X?
> 
> They are now present in 3.9-rc1, see a0b0197c (more specifically
> 85639910..d3d2b420) :)

Great.

> The actual accepted Kconfig symbol names are different though, so they
> should be changed in rt2x00 to match them (SOC_RT288X and SOC_RT305X).

Thanks. Note that I could not find an actual Kconfig symbol SOC_RT288X! 

Anyhow, I guess somebody has the (trivial) patch to convert
RALINK_RT...X and CONFIG_RALINK_RT...X to their SOC_* equivalents queued
for inclusion in v3.9-rcX. Is that correct?


Paul Bolle

