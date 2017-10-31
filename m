Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:50825 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbdJaH3u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 03:29:50 -0400
Received: by mail-wm0-f41.google.com with SMTP id s66so20214530wmf.5
        for <linux-wireless@vger.kernel.org>; Tue, 31 Oct 2017 00:29:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1509434718.4492.195.camel@coelho.fi>
References: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
 <1509434718.4492.195.camel@coelho.fi>
From: Chris Chiu <chiu@endlessm.com>
Date: Tue, 31 Oct 2017 15:29:48 +0800
Message-ID: <CAB4CAwd1yQFmE6fFa5d5NiAj1-aty=w-etTkBBYGUqrcByk2ow@mail.gmail.com> (sfid-20171031_082956_526209_14437E45)
Subject: Re: Need support for Intel new wifi module 9462NGW
To: Luca Coelho <luca@coelho.fi>
Cc: johannes.berg@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great. Thanks.

On Tue, Oct 31, 2017 at 3:25 PM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2017-10-31 at 12:13 +0800, Chris Chiu wrote:
>> Hi,
>
> Hi Chris,
>
>
>>     We just have the Intel new WiFi module 9462NGW from Acer and
>> tried
>> to verify if it works on the latest linux kernel. Unfortunately it
>> seems not even detected because the PCI ID seems unknown to the
>> iwlwifi driver. Then I add the following line to
>> drivers/net/wireless/intel/iwlwifi/pcie/drv.c
>> iwl_hw_card_ids
>> {IWL_PCI_DEVICE(0x31DC, 0x02A4, iwl9460_2ac_cfg)},
>>
>> dmesg shows the following
>>
>> [   12.994422] iwlwifi 0000:00:0c.0: Direct firmware load for
>> iwlwifi-9260-th-b0-jf-b0-33.ucode failed with error -2
>> [   12.994442] iwlwifi 0000:00:0c.0: Direct firmware load for
>> iwlwifi-9260-th-b0-jf-b0-32.ucode failed with error -2
>> [   12.994456] iwlwifi 0000:00:0c.0: Direct firmware load for
>> iwlwifi-9260-th-b0-jf-b0-31.ucode failed with error -2
>> [   12.994470] iwlwifi 0000:00:0c.0: Direct firmware load for
>> iwlwifi-9260-th-b0-jf-b0-30.ucode failed with error -2
>> [   12.994473] iwlwifi 0000:00:0c.0: no suitable firmware found!
>> [   12.994477] iwlwifi 0000:00:0c.0: minimum version required:
>> iwlwifi-9260-th-b0-jf-b0-30
>> [   12.994479] iwlwifi 0000:00:0c.0: maximum version supported:
>> iwlwifi-9260-th-b0-jf-b0-33
>>
>>
>>
>> I'm not able to find these missing files in linux-firmware.git and
>> any
>> other possible place. What's the status of supporting this 9462NGW?
>> Please let me know if any more information required. Thanks
>
> Unfortunately we have not published the firmware for this NIC yet.
> I'll try to get an approval to publish it today (or latest by the end
> of the week) and I'll let you know.
>
> --
> Cheers,
> Luca.
