Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39705 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbbCRVSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 17:18:02 -0400
Message-ID: <5509EB89.9080803@candelatech.com> (sfid-20150318_221807_080238_F1A5B660)
Date: Wed, 18 Mar 2015 14:18:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Orozco <felipe.orozco32@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: fast wireless restart on raspberry pi
References: <5162B74B-89E1-4A6D-AB76-8C5D55D15A99@gmail.com>
In-Reply-To: <5162B74B-89E1-4A6D-AB76-8C5D55D15A99@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2015 02:15 PM, Orozco wrote:
> Hello,
> 
> I am working on a project where I need to be able to modify a wireless 
> adapter's firmware. I'm trying to use the TP-LINK TL-WN821N with the 
> 8192cu driver and firmware on a Raspberry Pi 2. I am trying to be able to 
> quickly stop the transmission of packets then and just as quickly be able 
> to restart the transmission. Ideally, I would be able to do a single 
> stop/start in less time than it takes to transmit a packet.
> 
> I would be very thankful if someone could tell me where would be a good 
> place to start, and share any knowledge they have.

The only firmware I am aware of that is open-source is 'ath9k_htc'.

Not a simple piece of software, but at least you have the source...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

