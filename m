Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout01.t-online.de ([194.25.134.80]:60721 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1FJTT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 15:19:27 -0400
Message-ID: <4DF26E39.80701@t-online.de> (sfid-20110610_211937_551945_546761FA)
Date: Fri, 10 Jun 2011 21:19:21 +0200
From: =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: linux-wireless@vger.kernel.org, wwguy <wey-yi.w.guy@intel.com>,
	Stevie Trujillo <stevie.trujillo@gmail.com>
Subject: Re: Fwd: iwlagn: is tx_power_device_lmt a regulatory limit or a hardware
 limit?
References: <201105251813.36804.stevie.trujillo@gmail.com> <1306352560.20732.0.camel@wwguy-ubuntu> <201105252154.06204.stevie.trujillo@gmail.com> <1306376938.20732.2.camel@wwguy-ubuntu> <4DDE1458.9090004@t-online.de> <1306419109.20732.6.camel@wwguy-ubuntu> <4DF246D1.9000107@t-online.de> <1307727083.13397.57.camel@wwguy-huron> <4DF26175.2010506@t-online.de> <BANLkTimjLdr2Qb+yfUx84p4k2Oq8iumDhg@mail.gmail.com> <BANLkTimwn=sXSofPdQGg49Wsn6CxUbrOyw@mail.gmail.com>
In-Reply-To: <BANLkTimwn=sXSofPdQGg49Wsn6CxUbrOyw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 10.06.2011 20:42, schrieb Daniel Halperin:
> On Fri, Jun 10, 2011 at 11:24 AM, Richard Schütz<r.schtz@t-online.de>  wrote:
>>
>> According to [1] there are no countries that forbid tx power values lower than 20dBm in the 2.4 GHz band. The lowest value for the 5 GHz band listed is 17 dBm. So why are the Intel cards limited to 15dBm then for both bands? This value absolutely makes no sense in my view.
>>
>> [1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-regdb.git;a=blob;f=db.txt;hb=HEAD
>>
>
> Are you forgetting to account for the 3 dBi--7 dBi antenna gain?
> Dan

We are talking about wireless devices that are primarily used in 
portable computers. These do not have directional antennas usually. So 
there should be almost no antenna gain in most cases.

-- 
Regards,
Richard Schütz
