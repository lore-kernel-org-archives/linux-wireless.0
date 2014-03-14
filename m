Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53857 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbaCNP4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 11:56:08 -0400
Message-ID: <53232690.5040603@candelatech.com> (sfid-20140314_165615_056379_BE596C3B)
Date: Fri, 14 Mar 2014 08:56:00 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Florian Fainelli <f.fainelli@gmail.com>,
	"open list:ATHEROS ATH5K WIR..." <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: skb->priority magic values as part of UAPI headers?
References: <CAGVrzcaWBAo3kiQ5jLKv_XMyuUL-pf1Vj2kL8E8YVnLrm4Mj7A@mail.gmail.com> <CAGXE3d9s-FjVWF-y1n8Zrgzz3YZJ-yNnEQNoVeMfZYJRfbdXTA@mail.gmail.com>
In-Reply-To: <CAGXE3d9s-FjVWF-y1n8Zrgzz3YZJ-yNnEQNoVeMfZYJRfbdXTA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/14/2014 02:26 AM, Helmut Schaa wrote:
> On Thu, Mar 13, 2014 at 6:04 AM, Florian Fainelli <f.fainelli@gmail.com> wrote:
>> While browsing through net/wireless/util.c::cfg80211_classify8021d() I
>> stumbled upon the "magic values" range 256 to 263, should not those be
>> made part of some sort of user-space API header file, just so if
>> things need to be changed, they suddenly do not break?
> 
> I stumbled over that some time ago as well [1].
> The question is if this is required at all anymore or if it could just
> be removed.
> Helmut

I use it to easily poke user-space generated packets into specific
transmit queues on the NIC.  Please do not remove it.

Thanks,
Ben

> 
> [1] http://comments.gmane.org/gmane.linux.kernel.wireless.general/82689
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

