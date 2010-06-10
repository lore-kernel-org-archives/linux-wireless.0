Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41630 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab0FJFuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 01:50:12 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Jun 2010 22:50:12 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19472.32107.793016.762850@gargle.gargle.HOWL>
Date: Thu, 10 Jun 2010 11:21:39 +0530
To: Yatharth <y@yatharthgupta.com>
CC: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: issues while attempting ath9k_htc to work with ubuntu 10.04,
 device TL-WN721N
In-Reply-To: <4C1079E0.6090605@yatharthgupta.com>
References: <4C107563.3010709@yatharthgupta.com>
	<19472.30680.855993.112084@gargle.gargle.HOWL>
	<4C1078D4.3070604@yatharthgupta.com>
	<19472.31157.569068.781531@gargle.gargle.HOWL>
	<4C1079E0.6090605@yatharthgupta.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yatharth wrote:
> Here is the output of 'modinfo ath9k_hw'
> 
> Ubu-VM:~/tmp/compat-wireless-2010-06-05$ modinfo ath9k_hw
> filename:       /lib/modules/2.6.32-22-generic/updates/cw/ath9k_hw.ko

What is the 'cw' directory ?

On my machine, modinfo -n ath9k_hw shows:
/lib/modules/2.6.32-22-generic/updates/drivers/net/wireless/ath/ath9k/ath9k_hw.ko

You have some stray modules in your system, clean them up
and reload the driver.

Sujith
