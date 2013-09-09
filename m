Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57715 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3IIXKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 19:10:21 -0400
Message-ID: <522E5558.4070008@candelatech.com> (sfid-20130910_011024_365520_74573744)
Date: Mon, 09 Sep 2013 16:10:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: Always send management frames at MCS-0??
References: <522E1D31.2090403@candelatech.com> <CABPxzYLaLUdCXULmx7mV5Gk7L_RrnG4Zq-vO6XRCUt0pvm9SJA@mail.gmail.com>
In-Reply-To: <CABPxzYLaLUdCXULmx7mV5Gk7L_RrnG4Zq-vO6XRCUt0pvm9SJA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/2013 12:15 PM, Krishna Chaitanya wrote:
> On Tue, Sep 10, 2013 at 12:40 AM, Ben Greear <greearb@candelatech.com> wrote:
>> I had a user request that we support always sending management frames
>> (such as EAPOL) at the lowest rate.  Evidently, other equipment does this,
>> where as normal-ish supplicant/linux tends to send them at much higher
>> rates.
>>
>> Any suggestions on how to go about doing this properly?
>>
>> Any opinions on whether it's a good idea or not?
>
> EAPOL frames are data frams from WLAN perspective
> and are unicast, thats why we send at highest possible
> MCS supported. There is no advantage in forcing them to
> go at lower rates.
>

Would forcing them to a lower rate at least theoretically improve
the chance that the packets are properly delivered?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

