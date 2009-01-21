Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40544 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZAURLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 12:11:20 -0500
Message-ID: <49774F6B.2000105@candelatech.com> (sfid-20090121_181130_674882_D301F1DD)
Date: Wed, 21 Jan 2009 08:38:03 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Catalin Patulea <cat@vv.carleton.ca>
CC: linux-wireless@vger.kernel.org
Subject: Re: Atheros (madwifi/ath5k) virtual STA support
References: <9664a4720901201133g5671c7f0x718c4bd187b1d901@mail.gmail.com>
In-Reply-To: <9664a4720901201133g5671c7f0x718c4bd187b1d901@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Catalin Patulea wrote:
> Hi linux-wireless,
>
> I'm interested in virtual STA support in madwifi and/or ath5k on an
> AR5414 (AR5006XS). Specifically, I want one physical wireless adapter
> to act as an infrastructure client on multiple networks. I understand
> the network will most likely need to be on the same channel.
>
> This is currently prohibited by the madwifi driver (haven't looked at
> ath5k thoroughly). What's the underlying reason for this? Someone on
> IRC mentioned powersaving, beacon handling and "other reasons". Can
> anyone elaborate?
>
> Secondly, what is the procedure to get hardware documentation from
> Atheros? I'm specifically interested in the AR5414 datasheet.
>   
I have an old hacked up madwifi driver that supports this, and I'm currently
funding the development of this feature for ath5k, so hopefully it will
be available soon.  We will be integrating this feature set into our network
traffic generator tool, but I also hope that the patches get into the 
main kernel
for all to use freely.

Thanks,
Ben

> Thanks,
>
> Catalin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


-- 
Ben Greear <greearb@candelatech.com> 
Candela Technologies Inc  http://www.candelatech.com


