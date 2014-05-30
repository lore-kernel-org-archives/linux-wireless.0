Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37105 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaE3HKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 03:10:49 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so543183wiw.14
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 00:10:46 -0700 (PDT)
Message-ID: <53882EF4.4070105@gmail.com> (sfid-20140530_091053_295035_4B075048)
Date: Fri, 30 May 2014 10:10:44 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: piotr <pitkotko@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [Ilw] Wireless Centrino 2230-N issues
References: <536F6620.9030001@gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB303DF0FF6@HASMSX103.ger.corp.intel.com> <loom.20140530T020912-598@post.gmane.org> <53882EAD.4010609@gmail.com>
In-Reply-To: <53882EAD.4010609@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> I have similar problem. My system is Ubuntu 14.04 with kernel 3.13.0-24
>> installed on a new Toshiba laptop with N2230 wifi card. 
>> dmesg:
>> [  614.007461] iwlwifi 0000:01:00.0: Could not complete ALIVE transition: -5
>> [  614.007748] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -5
>> [  614.007790] iwlwifi 0000:01:00.0: Unable to initialize device.
>> [  614.008318] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
>> [  614.015390] iwlwifi 0000:01:00.0: Radio type=0x2-0x0-0x0
>> [  614.059495] iwlwifi 0000:01:00.0: Command COEX_PRIORITY_TABLE_CMD failed:
>> FW Error
>>
>> Is the card broken?
>>
>> Best,
>> Piotr
>>
>>
> 
> Can you try to add bt_coex_active=0 as debug parameter?
> 

Sorry, I meant *module* parameter. The mode is iwlwifi
Thanks
