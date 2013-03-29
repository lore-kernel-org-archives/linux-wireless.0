Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62255 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3C2PLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 11:11:34 -0400
Received: by mail-pa0-f45.google.com with SMTP id kl13so384137pab.32
        for <linux-wireless@vger.kernel.org>; Fri, 29 Mar 2013 08:11:33 -0700 (PDT)
Message-ID: <5155AF21.3010007@cardaccess-inc.com> (sfid-20130329_161138_221468_ADA56CAF)
Date: Fri, 29 Mar 2013 09:11:29 -0600
From: Brandt Deakin <bdeakin@cardaccess-inc.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Any suggestions for laptops with ath9k NIC?
References: <51548501.8010400@candelatech.com>
In-Reply-To: <51548501.8010400@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben,

It may not be an ideal solution, but I've used a Expresscard to PCI-E 
Mini adapter that basically plugs into the common express card slot and 
provides a pci-express slot so you can use your choice of AR9xxx radio.  
That way the BIOS of the Lenovos or HPs of the world don't stop you up.

Admittedly, it's less than elegant having a 10 cm card hanging out of 
your machine, but it does allow great flexibility in testing different 
radios.

If you have any difficulty finding an adapter PM me and tell you the one 
I use.

Brandt

On 3/28/2013 11:59 AM, Ben Greear wrote:
> Someone stole my previous laptop I was using for ath9k testing...
>
>
> Any suggestions for a new mid-range laptop that comes standard with
> ath9k NICs, or is known to work with ath9k NICs w/out having to
> hack the NIC eeprom or laptop BIOS?
>
> I'd prefer a 3x3, but not sure they exist, so a 2x2 a/b/g/n would be
> OK as well..
>
> Thanks,
> Ben
>

