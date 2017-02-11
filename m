Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:35170 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752201AbdBKEW5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 23:22:57 -0500
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
References: <0082a9e3-83f3-9bc3-af43-b890b91cfd93@candelatech.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <e71fe0b1-4482-b80b-2624-240b154ff980@dd-wrt.com> (sfid-20170211_052837_058007_1FAA6EF1)
Date: Sat, 11 Feb 2017 05:22:51 +0100
MIME-Version: 1.0
In-Reply-To: <0082a9e3-83f3-9bc3-af43-b890b91cfd93@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: VHT 160Mhz and nss related config.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i really can't believe this. if this is true the  160 mhz mode would not 
make any sense.
the maximum tx / rx rate for 4x4 vht80 and 2x2 vht160 is identical. so 
vht160 would not increase performance in any way

Am 10.02.2017 um 23:58 schrieb Ben Greear:
> So, it appears that the ath10k QCA9984 4x4 160Mhz chip can do 4x4 MIMO 
> at VHT80, but
> it can do only 2x2 MIMO at VHT160/80+80.
>
> When configuring a peer, we need to tell the firmware the number of 
> spatial streams
> of the peer at VHT160 and at VHT80 and lower.  They are not the same 
> value.
>
> I cannot think of any standard way to get this information based on 
> VHT capabilities
> and such.  Currently, one could just assume VHT160 NSS is 1/2 of the 
> VHT80 NSS,
> but that is unlikely to be true for all vendors.
>
> Any ideas?
>
> Thanks,
> Ben
>


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
