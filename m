Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4.mail-out.ovh.net ([178.32.228.4]:59157 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbbCMSgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 14:36:55 -0400
Received: from mail421.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id 76514FFA873
	for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2015 17:07:43 +0100 (CET)
Message-ID: <55030C42.6020206@armadeus.com> (sfid-20150313_193700_273157_23E57033)
Date: Fri, 13 Mar 2015 17:11:46 +0100
From: =?windows-1252?Q?S=E9bastien_Szymanski?=
	<sebastien.szymanski@armadeus.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
CC: Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	=?windows-1252?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
	Kumar Gala <galak@codeaurora.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Julien Boibessot <julien.boibessot@armadeus.com>
Subject: Re: [PATCH v6 0/6] wlcore: add device-tree support
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
In-Reply-To: <1426162154-8716-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 03/12/2015 01:09 PM, Eliad Peller wrote:
> 
> NOTE: all the platform patches were compile-tested
> only. I'm looking for some wl12xx card (that i should
> have somewhere) to test the wl12xx changes (wrt. clocks),
> but haven't found it yet.
> 

I have tested this series on a APF6 board, i.MX6 based board with a
Jorjin WG7311-0A Wifi/BT module which is based on the wl1271l.

It works. I was able to power up the wlan0 interface and ping google.

Best regards,

-- 
Sébastien Szymanski
