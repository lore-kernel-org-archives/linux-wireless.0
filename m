Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:57302 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161Ab1HSPpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 11:45:33 -0400
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0LQ6000A1MFUF3E0@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Fri, 19 Aug 2011 17:45:30 +0200 (CEST)
Received: from umic-i4-137-226-45-184.nn.rwth-aachen.de
 ([unknown] [137.226.45.184]) by relay-auth-1.ms.rz.rwth-aachen.de
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec  9 2008))
 with ESMTPA id <0LQ600CZKMFUKV10@relay-auth-1.ms.rz.rwth-aachen.de> for
 linux-wireless@vger.kernel.org; Fri, 19 Aug 2011 17:45:30 +0200 (CEST)
Subject: Re: Multiple virtual interfaces, ath9k
From: Hanno Wirtz <hanno.wirtz@comsys.rwth-aachen.de>
In-reply-to: <810b521f028c03b74ef357f22bd5d5ab.squirrel@mail.candelatech.com>
Date: Fri, 19 Aug 2011 17:45:31 +0200
Cc: linux-wireless@vger.kernel.org
Message-id: <1FEEF613-6A21-4853-8FD9-3F7F4078DC21@comsys.rwth-aachen.de> (sfid-20110819_174536_234968_4AC69752)
References: <6FA32078-B95C-47B6-98C8-17DE81CE5FE5@comsys.rwth-aachen.de>
 <810b521f028c03b74ef357f22bd5d5ab.squirrel@mail.candelatech.com>
To: greearb@candelatech.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 18.08.2011, at 07:05, greearb@candelatech.com wrote:

>> Hi,
>> 
>> I am having problems with the operation of multiple virtual interfaces.
>> A short scenario description :
> 
> Please post your hostapd configs for the two virtual APs.
> 
> Every virtual station must be on the same channel.  APs must
> be configured for the same channel, and stations must be able to
> associate with an AP on the same channel...
> 
> Thanks,
> Ben

Thanks for pointing me in the right direction, everything seems to work now. 
Once we let hostapd take care of everything concerning the virtual AP interfaces, the
concurrent operation of mixed interface configuration is working fine. 

Thanks again for the support, 

Hanno

