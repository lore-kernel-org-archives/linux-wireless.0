Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50169 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab2E2K6n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 06:58:43 -0400
Message-ID: <4FC4ABDF.7060105@openwrt.org> (sfid-20120529_125847_008682_53CD80FF)
Date: Tue, 29 May 2012 12:58:39 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Josef Semler <josef.semler@gmail.com>
CC: Adrian Chadd <adrian@freebsd.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL> <7759D07D-C2C8-48D8-8F44-687C7E85D188@gmail.com> <20416.35246.76971.129331@gargle.gargle.HOWL> <CAPsaeQPxh0Yd+GT3HbReAAtoPhKF2c3kOzgOPL6xK7NC=8J4qA@mail.gmail.com> <4FC0CE2B.9060005@openwrt.org> <9532BE30-26F1-42CF-9300-C25585B29300@gmail.com> <CAJ-VmomdZ+ww=iXF8R+st5HenGjchaV4De2pzzuY6Bu=6_n1YA@mail.gmail.com> <CAPsaeQNwWmAyzgGa3KjVv=nzwL3QHCDN-kHtaQWxKHOS4P+paA@mail.gmail.com>
In-Reply-To: <CAPsaeQNwWmAyzgGa3KjVv=nzwL3QHCDN-kHtaQWxKHOS4P+paA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-05-29 12:24 PM, Josef Semler wrote:
> 
> 
> 2012/5/26 Adrian Chadd <adrian@freebsd.org <mailto:adrian@freebsd.org>>
> 
>     Hi,
> 
>     If the device EEPROM states that it's a 2x2/3x3 device, it'll TX on
>     two/three streams.
> 
>     If it's something like an AR9281 where it's physically a 1T2R stream
>     device, that's what it'll transmit/receive on by default.
> 
>     If it's something like an AR9285 where it's physically a 1T1R stream
>     device with antenna diversity, that's also what you get.
> 
>     If the device EEPROM lies though, well, that's a problem. :-)
> 
> Installed OpenWRT für ubnt-nano on a Nanobridge. Well, NanoBridge should
> be 2x2 MIMO, but the device shows me AR7240 rev.2
> Is this a a EEPROM-lie and how can I correct it?
AR7240 is the CPU, not the wifi chip.

- Felix
