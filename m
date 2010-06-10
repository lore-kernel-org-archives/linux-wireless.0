Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41485 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab0FJFeT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 01:34:19 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Jun 2010 22:34:19 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19472.31157.569068.781531@gargle.gargle.HOWL>
Date: Thu, 10 Jun 2010 11:05:49 +0530
To: Yatharth <y@yatharthgupta.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: issues while attempting ath9k_htc to work with ubuntu 10.04,
 device TL-WN721N
In-Reply-To: <4C1078D4.3070604@yatharthgupta.com>
References: <4C107563.3010709@yatharthgupta.com>
	<19472.30680.855993.112084@gargle.gargle.HOWL>
	<4C1078D4.3070604@yatharthgupta.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yatharth wrote:
> I had checked earlier to ensure that everything was unloaded.
> 
> But I've done it again to make sure.
> Step 1 :  'sudo make unload'
> Step 2 : 'lsmod | grep ath'  [Returns Nothing, thus indicating none of 
> these modules are loaded]
> 
> If I do 'modprobe ath9k_htc' after this, I still get the same error

What does 'modinfo ath9k_hw' show ?

Sujith
