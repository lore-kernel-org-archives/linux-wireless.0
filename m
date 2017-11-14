Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.yrkesakademin.fi ([85.134.45.195]:58286 "EHLO
        mx2.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756719AbdKNVMp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 16:12:45 -0500
Subject: Re: iwlwifi 8265 firmware crash vith v34 on linux 4.14
To: Luciano Coelho <luciano.coelho@intel.com>,
        <linux-wireless@vger.kernel.org>
References: <b533ecc1-c4ce-b0fc-b7fb-b7beceb1f1cf@mageia.org>
 <1510689850.4011.96.camel@intel.com>
From: Thomas Backlund <tmb@mageia.org>
Message-ID: <6a8bf7c2-633b-4d45-7e80-91cb607320da@mageia.org> (sfid-20171114_221249_275747_98D75827)
Date: Tue, 14 Nov 2017 23:12:40 +0200
MIME-Version: 1.0
In-Reply-To: <1510689850.4011.96.camel@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Den 14.11.2017 kl. 22:04, skrev Luciano Coelho:
> Hi Thomas,
> 
> On Tue, 2017-11-14 at 21:49 +0200, Thomas Backlund wrote:
>> Running a Lenovo Yoga 720 with kernel 4.14, I pulled the:
>> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-
>> firmware.git
>> tags/iwlwifi-fw-2017-11-03
>>
>> to try the new fw version 34 on my:
>> 3f:00.0 Network controller [0280]: Intel Corporation Wireless 8265 /
>> 8275 [8086:24fd] (rev 78)
>>
>> And got this firmware crash and no wifi working:
>> (for reference firmware version 31.560484.0 from same git pull works)
>>
>>
>> [   11.423208] iwlwifi 0000:3f:00.0: Error sending SCAN_REQ_UMAC:
>> time out after 2000ms.
> 
> Yes, this was a screw up on my side regarding the FW API.  We have a
> bugzilla and a patch to fix it already (on my comment #6):
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=197591#c6
> 
> I'll try to get this into the first stable release for 4.14.
> 

Thanks. That patch fixed the crash here too :)
I'm now happily using v34 here

I'll queue it up in Mageia distro kernel too before landing the new 
firmwares there...


> Sorry for the trouble and thanks for reporting!

No worries :)

--
Thomas
