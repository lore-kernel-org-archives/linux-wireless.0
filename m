Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:55106 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab1CTTLS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 15:11:18 -0400
Subject: Re: ath9k stopped queue bug
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
In-Reply-To: <AANLkTin0ixVQJA6B6Et1AUqdkhu1b+hv6Gxu_SQWEMzD@mail.gmail.com>
References: <1298390485.2575.6.camel@gnutoo-laptop>
	 <AANLkTin0ixVQJA6B6Et1AUqdkhu1b+hv6Gxu_SQWEMzD@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Mar 2011 20:05:34 +0100
Message-ID: <1300647934.31197.0.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-23 at 11:04 +0530, Mohammed Shafi wrote:
> please try with debug messages enabled sudo modprobe ath9k debug=0x2
> (or)
> sudo modprobe debug=0x82 (this produces lots of log) 
# cat /sys/kernel/debug/ieee80211/phy*/queues
00: 0x00000000/0
01: 0x00000000/0
02: 0x00000001/965
03: 0x00000000/0
# uname -a
Linux gnutoo-laptop 2.6.38-gnutoo-0001 #2 SMP Sat Mar 19 19:07:58 CET
2011 x86_64 GNU/Linux

The problem persist and dmesg still doesn't have the debug infos...

Denis.


