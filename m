Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43261 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab1ECQgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 12:36:45 -0400
Message-ID: <4DC02F1A.7010402@candelatech.com> (sfid-20110503_183659_019405_1F68660C)
Date: Tue, 03 May 2011 09:36:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for 3x3 Atheros NICs using ath9k driver.
References: <4DBF1967.9010604@candelatech.com> <BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>
In-Reply-To: <BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2011 11:13 PM, Adrian Chadd wrote:
> The AR9160/SR71-A should be supported by ath9k. They're just 2x2
> stream devices using 3 radios.
>
> What do you mean by "not even supported" ?
>
> If the SR71-A isn't working for you then please email the ath9k list
> and I'll take a look. I have a bunch of SR71-A hardware here to tinker
> with.

The ath9k didn't even recognize the NIC, and lspci showed some 5xxx
chipset.

Other SR71-A NICs work just fine, so it's just a subset that is
broken.  I'll put it in a system later today and get you
a verbose lspci listing.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

