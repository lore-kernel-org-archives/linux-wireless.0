Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33659 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab0HCPKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 11:10:47 -0400
Message-ID: <4C58316C.2050009@candelatech.com>
Date: Tue, 03 Aug 2010 08:10:36 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Ryszard <ryszard99@gmail.com>
CC: Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Subject: Re: virtual access point setup
References: <AANLkTik0Ebk6zcTi29pofUvzmVDmRwi4hthj+66k9-V0@mail.gmail.com>	<4C57A16A.90501@candelatech.com>	<AANLkTi=vrwrqJwB+OH_d6kUWhqNN6LkzeUpuAktd=87H@mail.gmail.com> <AANLkTim5ApsX4VwqR1+Fw1E-+iey8G5HMKgAXbXh+6zu@mail.gmail.com>
In-Reply-To: <AANLkTim5ApsX4VwqR1+Fw1E-+iey8G5HMKgAXbXh+6zu@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2010 10:46 PM, Ryszard wrote:
> hey ben,  any idea on which config would be best for an AMD geode proc?
> i'm thinking either the c3 or p4 compat configs ..

You could start with either, and then change the CPU type as needed.

You only need the -compat version if you are running on older user-space
OS's..so you might try w/out compat first.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
