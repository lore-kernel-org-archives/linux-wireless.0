Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40302 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaETXV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 19:21:27 -0400
Message-ID: <537BE376.2040703@candelatech.com> (sfid-20140521_012130_676828_A2E3D19F)
Date: Tue, 20 May 2014 16:21:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Junguk Cho <jmanbal@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Questions about VIRTUAL NETWORK INTERFACE
References: <CAMNaBtPyqgkZ5T_Kegz3YGP3RTv7xzpWFnRt2CRxCxrSAn_Taw@mail.gmail.com>
In-Reply-To: <CAMNaBtPyqgkZ5T_Kegz3YGP3RTv7xzpWFnRt2CRxCxrSAn_Taw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/2014 02:21 PM, Junguk Cho wrote:
> Hello, I tried to use VIRTUAL NETWORK INTERFACE with 802.11 network.
> Based on this web
> page(http://wireless.kernel.org/en/users/Documentation/iw/vif/), we
> can use mac80211 Multiple Virtual Interface(vif) with one physical
> wireless network card.
> 
> I used N150UA usb wireless network card and recent version of linux
> kernel(3.14). I can create virtual interfaces(vifs) with iw command
> line tools. However, only one vif can associated with AP.
> 
> I think it is limited by my wireless network card.
> 
> So, does anyone succeed associating multiple APs with VIF by using iw command?
> If so, please let me know which wireless network card used.
> 
> Also, are there list of devices which supports those functionality.

This page may help a bit.  I have good experience with AR9380 pci-e NICs
and recent kernels.

http://www.candelatech.com/vsta.php

Thanks,
Ben

> 
> 
> Thanks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

