Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59342 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752209AbdCBTbC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 14:31:02 -0500
Message-ID: <1488479939.23555.1.camel@sipsolutions.net> (sfid-20170302_203233_237992_CFE843B6)
Subject: Re: Usage of WoWLAN with iwlwifi driver (Device phy0 failed to
 suspend async: error -16)
From: Johannes Berg <johannes@sipsolutions.net>
To: Oliver Freyermuth <o.freyermuth@googlemail.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 02 Mar 2017 19:38:59 +0100
In-Reply-To: <0cd984fd-3d26-15b2-03ce-69cdb7c0e434@googlemail.com> (sfid-20170302_192039_705080_F5833A6D)
References: <cc035655-0869-f7d7-bdb4-61e7a38b7fc8@googlemail.com>
         <1487938277.2540.13.camel@sipsolutions.net>
         <5d69cf9b-1113-835a-8423-3796586eae20@googlemail.com>
         <1487965047.30601.2.camel@sipsolutions.net>
         <6337fa40-adcc-b889-1842-16e0f316ea3e@googlemail.com>
         <1488444909.8390.11.camel@sipsolutions.net>
         <0cd984fd-3d26-15b2-03ce-69cdb7c0e434@googlemail.com>
         (sfid-20170302_192039_705080_F5833A6D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Yes. Does it print something to that effect at resume time? I think
> > it should.
> 
> Oh yes - I totally missed that since it came quite late in the resume
> cycle:
> 
> [12386.085899] iwlwifi 0000:0a:00.0: System wakeup disabled by ACPI
> [12386.088449] iwlwifi 0000:0a:00.0: Device was reset during suspend
> 
> I guess the "Device was reset during suspend" means my firmware did
> something uncool like cutting the power to it (it's a laptop, but I
> suspended with power supply staying connected). 

Yes.

> UEFI options are very limited, so I guess I'm just out of luck with
> this hardware. 

Yeah, most likely.

> I have another laptop with the same iwlwifi card (but newer HW
> revision), a comparable Gentoo 
> installation but with an unlocked UEFI. 
> I'll play with it on the weekend and report back in case I find
> anything different there. 

Ok. I *have* gotten this to work on some (old) laptops, but not
generally.

johannes
