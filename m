Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64150 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3ABXMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 18:12:20 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so6820864wgb.35
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 15:12:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50E49D03.60207@openwrt.org>
References: <773DB8A82AB6A046AE0195C68612A31901412125@sbs2003.acksys.local>
	<CAD2nsn1UyObSBrpAq+oJOm+Q1PuC=Y9J0cFH3aC3LkPei6QZYw@mail.gmail.com>
	<CAJ-VmomdWE2d3qUzgOR0=pnoKzeJpFG1rOT1XH3gTB-dtosuVg@mail.gmail.com>
	<50E2FE5E.6040300@openwrt.org>
	<CAJ-Vmo=kbvLSdA8wGaRacAOvoZBdksJwQZ+Z52RbiUAq-T4weA@mail.gmail.com>
	<016301cde8eb$8b92ba60$a2b82f20$@acksys.fr>
	<CAJ-VmokpOeKc6zR+JUWqzZ1tsRNdWR8gK9OTRb5HsUnKYVE__w@mail.gmail.com>
	<018d01cde90c$c7145410$553cfc30$@acksys.fr>
	<CAJ-VmomkzNgSyicAwcj_TWg24v-DH+Q7U6ifXFFognx-7nEZvw@mail.gmail.com>
	<50E49D03.60207@openwrt.org>
Date: Wed, 2 Jan 2013 15:12:18 -0800
Message-ID: <CAJ-Vmonp=PZckQgH76xLCf7G56VaZP01cSKxAjC8sr9D+RG3zw@mail.gmail.com> (sfid-20130103_001225_009846_BD873FE0)
Subject: Re: [RFC] ATH9K: infinite loop in Tasklet
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: voncken <cedric.voncken@acksys.fr>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. in the longer term, sure. Right now, is the driver setup for the
interrupt hijinx you may need for NAPI? (ie, killing and restarting RX
interrupts as needed?)


Adrian
