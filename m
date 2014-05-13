Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:46075 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaEMRBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 13:01:08 -0400
Received: by mail-la0-f52.google.com with SMTP id gl10so505750lab.25
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2014 10:01:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1405130906520.29439@admin.chi.technicality.org>
References: <CANUX_P1GBeBdPkci6c9cDyz4C4uxA6ktaGvwgPQTDzEPsuEPgg@mail.gmail.com>
	<alpine.DEB.2.02.1405130906520.29439@admin.chi.technicality.org>
Date: Tue, 13 May 2014 20:01:07 +0300
Message-ID: <CANUX_P3TaX_2BFg6qxjiFYLvUiaaFYqdxWbkCbymA0sGrWh4Gg@mail.gmail.com> (sfid-20140513_190113_495039_B28B3693)
Subject: Re: [ANN] New firmware for Intel 7260 / 3160 - 22.212.9.0
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Nate Carlson <linux-wireless@natecarlson.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2014 at 5:15 PM, Nate Carlson
<linux-wireless@natecarlson.com> wrote:
> On Mon, 28 Apr 2014, Emmanuel Grumbach wrote:
>>
>> The firmwares are available at [1].
>> I will send a pull request to linux-firmware.git soon.
>>
>> The new firmware's version number is 22.212.9.0:
>>
>> $ dmesg | grep loaded\ firmware
>> loaded firmware version 22.212.9.0 op_mode iwlmvm
>>
>> [1] http://wireless.kernel.org/en/users/Drivers/iwlwifi#Firmware
>
>
> Hi,
>
> I've just noticed that the firmware, as downloaded from both your git tree
> and from the wireless.kernel.org URL, reports that it is v23.214.9.0 --
>
>
> $ dmesg | grep loaded\ firmware
> [   16.628491] iwlwifi 0000:03:00.0: loaded firmware version 23.214.9.0
> op_mode iwlmvm
>
> md5sum of installed firmware when the driver was loaded and reported that:
> $ md5sum /lib/firmware/iwlwifi-7260-9.ucode
> 1005c3b82879ecfa0d60544a78de7f92  /lib/firmware/iwlwifi-7260-9.ucode
>
> md5sum of the firmware from 'iwlwifi-7260-ucode-22.212.9.0.tgz':
> $ md5sum iwlwifi-7260-ucode-22.212.9.0/iwlwifi-7260-9.ucode
> 1005c3b82879ecfa0d60544a78de7f92
> iwlwifi-7260-ucode-22.212.9.0/iwlwifi-7260-9.ucode
>
So yeah  - the name of the directory / tarball isn't the same as the
version reported here. Sorry for that. No impact though.
