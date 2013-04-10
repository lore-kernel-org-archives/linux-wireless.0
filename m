Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46863 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934808Ab3DJXbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 19:31:08 -0400
Received: by mail-wi0-f180.google.com with SMTP id c10so1015223wiw.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 16:31:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5165F491.2060301@openwrt.org>
References: <5165E1C2.4020407@net.t-labs.tu-berlin.de>
	<CAJ-Vmo=boxae6Cs+yDerTCGOa=rq-dZeNLeTjGjroBMxwsfU4A@mail.gmail.com>
	<5165F491.2060301@openwrt.org>
Date: Wed, 10 Apr 2013 16:31:07 -0700
Message-ID: <CAJ-VmokR8SM9rFMqXbVf0AmumrEzhMCiTXR=XB5ePutD7JHpSw@mail.gmail.com> (sfid-20130411_013114_773573_59D6C636)
Subject: Re: [ath9k-devel] [RFC] ath9k: Respect current txpower setting
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Tobias Steinicke <tobias.steinicke@net.t-labs.tu-berlin.de>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 April 2013 16:24, Felix Fietkau <nbd@openwrt.org> wrote:

> I think TPC power value mappings were only problematic in pre-802.11n
> chipsets, all chipsets supported by ath9k should be fine. There may be
> some minor changes missing to enable it on some older chipsets, but
> other than that it should be functional.

.. except AR9285.

.. and I think maybe AR9485, and some of the Osprey era NICs that have
different CCK target power offset values. :-)

It's worth reviewing. I had to do this to get TPC working on AR9285,
and I haven't yet pushed it into FreeBSD (because at the time I didn't
have a spectrum analyser. Now, however, I do..)



Adrian
