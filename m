Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38658 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab2CLWNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 18:13:17 -0400
Received: by eaaq12 with SMTP id q12so1488841eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2012 15:13:16 -0700 (PDT)
Message-ID: <4F5E7515.8060801@openwrt.org> (sfid-20120312_231321_243203_F090B422)
Date: Mon, 12 Mar 2012 23:13:41 +0100
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Hacking PCI-ids to allow Atheros NIC into Lenovo laptop.
References: <4F5E7031.4000401@candelatech.com>
In-Reply-To: <4F5E7031.4000401@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Le 12/03/2012 22:52, Ben Greear a écrit :
> It seems we bought a Lenovo laptop that has a BIOS lock where it will only
> support certain wifi NICs based on the pci-id. It came with an Intel
> NIC, so at least that ID must work...
>
> One way around this might be to over-write the pci-id of an Atheros NIC
> in it's non-volatile storage to make it look like an Intel, at least until
> the kernel boots.
>
> Then maybe add some sort of ugly code to force the Atheros driver
> to manage this Intel pci-id (and probably disable the same pci-id in
> the Intel driver).
>
> Has anyone tried doing anything like this? Any suggestions for a cleaner
> way to go about this?

The only viable hack that I have came to with my laptop (Lenovo X61) is 
to have a patched BIOS. Fortunately the web is full of such modified 
BIOSes enabling various features (SATA2 vs SATA1, Wireless NICs 
whitelisting ...)
--
Florian
