Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60331 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab3ABXWb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 18:22:31 -0500
Message-ID: <50E4C133.8020909@openwrt.org> (sfid-20130103_002235_893758_907E97FF)
Date: Thu, 03 Jan 2013 00:22:27 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: voncken <cedric.voncken@acksys.fr>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] ATH9K: infinite loop in Tasklet
References: <773DB8A82AB6A046AE0195C68612A31901412125@sbs2003.acksys.local> <CAD2nsn1UyObSBrpAq+oJOm+Q1PuC=Y9J0cFH3aC3LkPei6QZYw@mail.gmail.com> <CAJ-VmomdWE2d3qUzgOR0=pnoKzeJpFG1rOT1XH3gTB-dtosuVg@mail.gmail.com> <50E2FE5E.6040300@openwrt.org> <CAJ-Vmo=kbvLSdA8wGaRacAOvoZBdksJwQZ+Z52RbiUAq-T4weA@mail.gmail.com> <016301cde8eb$8b92ba60$a2b82f20$@acksys.fr> <CAJ-VmokpOeKc6zR+JUWqzZ1tsRNdWR8gK9OTRb5HsUnKYVE__w@mail.gmail.com> <018d01cde90c$c7145410$553cfc30$@acksys.fr> <CAJ-VmomkzNgSyicAwcj_TWg24v-DH+Q7U6ifXFFognx-7nEZvw@mail.gmail.com> <50E49D03.60207@openwrt.org> <CAJ-Vmonp=PZckQgH76xLCf7G56VaZP01cSKxAjC8sr9D+RG3zw@mail.gmail.com>
In-Reply-To: <CAJ-Vmonp=PZckQgH76xLCf7G56VaZP01cSKxAjC8sr9D+RG3zw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-01-03 12:12 AM, Adrian Chadd wrote:
> .. in the longer term, sure. Right now, is the driver setup for the
> interrupt hijinx you may need for NAPI? (ie, killing and restarting RX
> interrupts as needed?)
Should be easy enough to add. I'll look into this when I find the time.

- Felix

