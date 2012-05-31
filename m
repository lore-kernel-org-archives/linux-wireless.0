Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53426 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2EaFS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 01:18:26 -0400
Message-ID: <4FC6FF1B.7050201@candelatech.com> (sfid-20120531_071830_177093_608F71A4)
Date: Wed, 30 May 2012 22:18:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Ath9k performance testing results (AR9380)
References: <4FC55443.4020003@candelatech.com> <20422.56339.579488.464864@gargle.gargle.HOWL>
In-Reply-To: <20422.56339.579488.464864@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2012 07:48 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> I am not sure why there is such a big difference, but possibly
>> sending wifi is harder than receiving it, and the Atom processor
>> just can't keep up.
>
> I have a small Atom-based netbook, I'll try with it and see what numbers
> can be seen. It's a pain to pry it open and bolt a different card, though. :)

We had to install a hacked 'white-listed' BIOS to get a Lenovo laptop to even POST with
an Atheros NIC in it, so if your NIC works w/out having to hack the BIOS, please
let me know :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
