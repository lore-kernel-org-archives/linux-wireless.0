Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61198 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaFBGQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 02:16:03 -0400
Received: by mail-ob0-f177.google.com with SMTP id wp4so3980210obc.36
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jun 2014 23:16:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20140530T111920-677@post.gmane.org>
References: <536F6620.9030001@gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB303DF0FF6@HASMSX103.ger.corp.intel.com>
	<loom.20140530T020912-598@post.gmane.org>
	<53882EAD.4010609@gmail.com>
	<53882EF4.4070105@gmail.com>
	<loom.20140530T111920-677@post.gmane.org>
Date: Mon, 2 Jun 2014 09:16:02 +0300
Message-ID: <CANUX_P0JenW+GDT3N0Qj5BPGqMXqUWiBnj=TQ+nMEsjS4HFm1w@mail.gmail.com> (sfid-20140602_081608_005086_A564AB5A)
Subject: Re: [Ilw] Wireless Centrino 2230-N issues
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: piotr <pitkotko@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> >>
>> >> I have similar problem. My system is Ubuntu 14.04 with kernel 3.13.0-24
>> >> installed on a new Toshiba laptop with N2230 wifi card.
>> >> dmesg:
>> >> [  614.007461] iwlwifi 0000:01:00.0: Could not complete ALIVE
> transition: -5
>> >> [  614.007748] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -5
>> >> [  614.007790] iwlwifi 0000:01:00.0: Unable to initialize device.
>> >> [  614.008318] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
>> >> [  614.015390] iwlwifi 0000:01:00.0: Radio type=0x2-0x0-0x0
>> >> [  614.059495] iwlwifi 0000:01:00.0: Command COEX_PRIORITY_TABLE_CMD
> failed:
>> >> FW Error
>> >>
>> >> Is the card broken?
>> >>
>> >> Best,
>> >> Piotr
>> >>
>> >>
>> >
>> > Can you try to add bt_coex_active=0 as debug parameter?
>> >
>>
>> Sorry, I meant *module* parameter. The mode is iwlwifi
>
> Thanks for quick reply.
>
> I've tried your suggestion on the fly:
>
> modprobe -rv iwlwifi
> modprobe iwlwifi bt_coex_active=0
>
> After this, I get "N" from "more
> /sys/module/iwlwifi/parameters/bt_coex_active", but it seems not to take any
> effect on device functioning nor on the kernel messages.
> Is this what you meant? BTW, the bluetooth seems to work.
>

Can you please send the whole dmesg output?
