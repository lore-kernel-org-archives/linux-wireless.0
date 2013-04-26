Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:37400 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab3DZUUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 16:20:11 -0400
Received: by mail-qe0-f43.google.com with SMTP id f6so2996606qej.2
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2013 13:20:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <517A427E.3010809@broadcom.com>
References: <CACaajQtmPLHBStjPT4L5pa6s2nVC2zwxCa3v+Z10ZBFCXp+dDw@mail.gmail.com>
 <CAGRGNgX0P8+6xT-hi81Y+gE47ZD2JPRuD=4TeXePHC_2bQhxSg@mail.gmail.com>
 <CACaajQusznz4ATwN35i8S=NRbYnuRR0GF=1TE89Mpi3dmyKaDA@mail.gmail.com>
 <CAGRGNgWEDjzP5GG6ZJHQ4tc+G+hKdJdateAc13NppEMaDckGHA@mail.gmail.com>
 <CACaajQvv975G0oOu73aWxfy3iQLiV2gtkzk-E3jhBcOjZxa+pA@mail.gmail.com>
 <517199D4.9070702@broadcom.com> <CACaajQuC3QpcEVnDZA7nCJ_6mmSNafn5zZp=QMdomzHUQ7AsSQ@mail.gmail.com>
 <CACaajQtbR5Utac82Zik00dQZYiE=tcDRmhWDt17BYEHDOj1Z2w@mail.gmail.com> <517A427E.3010809@broadcom.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Sat, 27 Apr 2013 00:19:53 +0400
Message-ID: <CACaajQsf8cgG9DQ-QuWY5EqeUNq4RgX9CMgQ8bZi7s8UJzCE_g@mail.gmail.com> (sfid-20130426_222017_348379_9EB8D2ED)
Subject: Re: very bad work of wl (bcm 43228)
To: Arend van Spriel <arend@broadcom.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Larry Finger <larry.finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/4/26 Arend van Spriel <arend@broadcom.com>:
> Not really. You could try disabling powersave. I am not very familiar with
> wl driver.
>
> $ iw dev wlanX power_save off
>
> Can you still provide lsusb and lspci for all devices?
>
> Gr. AvS


I'm already disable powersaving but it not helps. My lspci and lsusb:

00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor
Family DRAM Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
Core Processor Family Integrated Graphics Controller (rev 09)
00:14.0 USB controller: Intel Corporation Panther Point USB xHCI Host
Controller (rev 04)
00:16.0 Communication controller: Intel Corporation Panther Point MEI
Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation Panther Point USB Enhanced
Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation Panther Point High Definition
Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation Panther Point PCI Express Root
Port 1 (rev c4)
00:1c.1 PCI bridge: Intel Corporation Panther Point PCI Express Root
Port 2 (rev c4)
00:1c.2 PCI bridge: Intel Corporation Panther Point PCI Express Root
Port 3 (rev c4)
00:1d.0 USB controller: Intel Corporation Panther Point USB Enhanced
Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation Panther Point LPC Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation Panther Point 6 port SATA
Controller [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation Panther Point SMBus Controller (rev 04)
03:00.0 Network controller: Broadcom Corporation BCM43228 802.11a/b/g/n
04:00.0 Ethernet controller: Broadcom Corporation NetLink BCM57785
Gigabit Ethernet PCIe (rev 10)
04:00.1 SD Host controller: Broadcom Corporation NetXtreme BCM57765
Memory Card Reader (rev 10)


Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 003: ID 0489:e046 Foxconn / Hon Hai
Bus 001 Device 004: ID 04f2:b336 Chicony Electronics Co., Ltd




--
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
