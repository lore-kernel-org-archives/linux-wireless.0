Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37434 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2LDRGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 12:06:20 -0500
Message-ID: <50BE2D84.4010809@candelatech.com> (sfid-20121204_180623_496699_D5E53ED1)
Date: Tue, 04 Dec 2012 09:06:12 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: Allow over-riding regdomain in NIC when CFG80211_CERTIFICATION_ONUS
 is enabled?
References: <50BD2B46.5080706@candelatech.com> <CAB=NE6XQGKTFq_yQt7QuFmozNCDT42w7B8qSdv_FY4arOQziZg@mail.gmail.com>
In-Reply-To: <CAB=NE6XQGKTFq_yQt7QuFmozNCDT42w7B8qSdv_FY4arOQziZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/03/2012 03:16 PM, Luis R. Rodriguez wrote:
> On Mon, Dec 3, 2012 at 2:44 PM, Ben Greear <greearb@candelatech.com> wrote:
>> There are out-of-tree patches for ath9k (at least) that allow overriding the
>> eeprom reg domain via a module option.
>>
>> Any chance something like that could make it upstream if it were dependent
>> on CFG80211_CERTIFICATION_ONUS?
>>
>> (We recently got a batch of wpea-127n NICs with country-code of TW, which
>> reminded me of this problem).
>
> I think it would be reasonable, but note Adrian's points. We likely
> would need then only to be able to change regulatory domains for only
> regulatory domains that match the CTLs programmed in. I'll also note
> that the default CTL is actually a high value rather than no
> transmit...

How do I get this information?  What is a CTL anyway?

Thanks,
Ben

>
>    Luis
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

