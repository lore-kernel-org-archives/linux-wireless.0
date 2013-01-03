Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57099 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3ACBgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 20:36:35 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so6932559wey.5
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 17:36:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50E4C133.8020909@openwrt.org>
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
	<CAJ-Vmonp=PZckQgH76xLCf7G56VaZP01cSKxAjC8sr9D+RG3zw@mail.gmail.com>
	<50E4C133.8020909@openwrt.org>
Date: Wed, 2 Jan 2013 17:36:33 -0800
Message-ID: <CAJ-VmonMErMLnPOeFBj_qowS4G6oc+-P5kcun9nk60fE7vLWaw@mail.gmail.com> (sfid-20130103_023641_139881_03C49C72)
Subject: Re: [RFC] ATH9K: infinite loop in Tasklet
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: voncken <cedric.voncken@acksys.fr>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 January 2013 15:22, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2013-01-03 12:12 AM, Adrian Chadd wrote:
>> .. in the longer term, sure. Right now, is the driver setup for the
>> interrupt hijinx you may need for NAPI? (ie, killing and restarting RX
>> interrupts as needed?)
> Should be easy enough to add. I'll look into this when I find the time.

Cool, thanks. I'll go back and lurk, at least until there's more
spectral/DFS/IBSS stuff to figure out.



Adrian
