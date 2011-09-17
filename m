Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:38884 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab1IQXUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 19:20:05 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p8HNK3JM002474
	for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2011 19:20:03 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 3BDB31E007D
	for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2011 19:20:02 -0400 (EDT)
Message-ID: <4E752B9A.6000509@lockie.ca> (sfid-20110918_012009_595271_D23969C1)
Date: Sat, 17 Sep 2011 19:22:02 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: did my hardware die?
References: <4E7521C9.5060801@lockie.ca>
In-Reply-To: <4E7521C9.5060801@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/17/11 18:40, James wrote:
> Does it mean my hardware died since dmesg shows nothing related to ath?
>
> # dmesg | grep ath
>
> # lspci
> 02:09.0 Network controller: Atheros Communications Inc. AR5008 
> Wireless Network Adapter (rev 01)
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Kernel 3.6.36.4 sees the hardware:

ath9k 0000:02:08.0: PCI INT A -> Link[LNKA] -> GSI 18 (level, low) -> IRQ 18
ath: EEPROM regdomain: 0x10
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: CO
ath: Regpair used: 0x10
ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
Registered led device: ath9k-phy0

Kernel-3.0.4 does not.
