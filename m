Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:59218 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFDTZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 15:25:33 -0400
Received: by mail-oa0-f50.google.com with SMTP id i7so8394949oag.23
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 12:25:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20140603T000209-622@post.gmane.org>
References: <536F6620.9030001@gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB303DF0FF6@HASMSX103.ger.corp.intel.com>
	<loom.20140530T020912-598@post.gmane.org>
	<53882EAD.4010609@gmail.com>
	<53882EF4.4070105@gmail.com>
	<loom.20140530T111920-677@post.gmane.org>
	<CANUX_P0JenW+GDT3N0Qj5BPGqMXqUWiBnj=TQ+nMEsjS4HFm1w@mail.gmail.com>
	<loom.20140603T000209-622@post.gmane.org>
Date: Wed, 4 Jun 2014 22:25:32 +0300
Message-ID: <CANUX_P22M85RN_+-GnZ0fEtz7Ch-ei_KbXhjcZ5H7i0Sn30Vhg@mail.gmail.com> (sfid-20140604_212536_434261_1C17C3B2)
Subject: Re: [Ilw] Wireless Centrino 2230-N issues
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: piotr <pitkotko@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>>
>> Can you please send the whole dmesg output?
>
> [115535.469083] iwlwifi 0000:01:00.0: Could not complete ALIVE transition: -5
> [115535.469370] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -5
> [115535.469412] iwlwifi 0000:01:00.0: Unable to initialize device.
> [115535.471365] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
> [115535.478424] iwlwifi 0000:01:00.0: Radio type=0x2-0x0-0x0
> [115535.525086] iwlwifi 0000:01:00.0: Command COEX_PRIORITY_TABLE_CMD
> failed: FW Error
>

Ok, please do the following:

modprobe -r iwldvm
modprobe iwlwifi fw_restart=0 debug=0xffffffff

then, please send the whole dmesg output.
