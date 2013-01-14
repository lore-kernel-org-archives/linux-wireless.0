Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37570 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab3ANHHh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 02:07:37 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Q: how to update platform power state for the network driver
References: <6929081.7c7blFVDp4@lx-vladimir> <1363680.r8KF83dygC@lx-vladimir>
	<CAGRGNgVUq=8H-r=tA3W5ojyfWPfPt8YHB2zDVpK5EWeF-=5unw@mail.gmail.com>
Date: Mon, 14 Jan 2013 09:07:36 +0200
In-Reply-To: <CAGRGNgVUq=8H-r=tA3W5ojyfWPfPt8YHB2zDVpK5EWeF-=5unw@mail.gmail.com>
	(Julian Calaby's message of "Fri, 11 Jan 2013 11:45:43 +1100")
Message-ID: <87y5fwz1hj.fsf@purkki.adurom.net> (sfid-20130114_080741_486696_E62EEB54)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

>> #include <linux/power_supply.h>
>> int power_supply_is_system_supplied(void);
>>
>> returns:
>> positive if system is AC supplied,
>> 0 if battery supplied
>> negative on error
>
> One minor point: you might want to add the ability to override this,
> even if it's only through debugfs so that people testing the code, or
> with unusual requirements can set this how they want / need it.

I'm also worried that this power_supply interface is not supported in
all platforms. Does anyone know how widely it's used?

-- 
Kalle Valo
