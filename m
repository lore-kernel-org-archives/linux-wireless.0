Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39069 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab0HCUFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 16:05:01 -0400
Received: by eya25 with SMTP id 25so1775103eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Aug 2010 13:05:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C58316C.2050009@candelatech.com>
References: <AANLkTik0Ebk6zcTi29pofUvzmVDmRwi4hthj+66k9-V0@mail.gmail.com>
	<4C57A16A.90501@candelatech.com>
	<AANLkTi=vrwrqJwB+OH_d6kUWhqNN6LkzeUpuAktd=87H@mail.gmail.com>
	<AANLkTim5ApsX4VwqR1+Fw1E-+iey8G5HMKgAXbXh+6zu@mail.gmail.com>
	<4C58316C.2050009@candelatech.com>
Date: Wed, 4 Aug 2010 06:05:00 +1000
Message-ID: <AANLkTikqGUToB6-ULz4Ng0xDiYJoaLBtvkMkLUs5vG5z@mail.gmail.com>
Subject: Re: virtual access point setup
From: Ryszard <ryszard99@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ah, good tip, thx!

On 4 August 2010 01:10, Ben Greear <greearb@candelatech.com> wrote:
>
> On 08/02/2010 10:46 PM, Ryszard wrote:
>>
>> hey ben,  any idea on which config would be best for an AMD geode proc?
>> i'm thinking either the c3 or p4 compat configs ..
>
> You could start with either, and then change the CPU type as needed.
>
> You only need the -compat version if you are running on older user-space
> OS's..so you might try w/out compat first.
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
