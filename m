Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42892 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751658AbdJaHZV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 03:25:21 -0400
Message-ID: <1509434718.4492.195.camel@coelho.fi> (sfid-20171031_082525_018581_BD81C9B9)
From: Luca Coelho <luca@coelho.fi>
To: Chris Chiu <chiu@endlessm.com>, johannes.berg@intel.com,
        linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Date: Tue, 31 Oct 2017 09:25:18 +0200
In-Reply-To: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
References: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Need support for Intel new wifi module 9462NGW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-31 at 12:13 +0800, Chris Chiu wrote:
> Hi,

Hi Chris,


>     We just have the Intel new WiFi module 9462NGW from Acer and
> tried
> to verify if it works on the latest linux kernel. Unfortunately it
> seems not even detected because the PCI ID seems unknown to the
> iwlwifi driver. Then I add the following line to
> drivers/net/wireless/intel/iwlwifi/pcie/drv.c
> iwl_hw_card_ids
> {IWL_PCI_DEVICE(0x31DC, 0x02A4, iwl9460_2ac_cfg)},
> 
> dmesg shows the following
> 
> [   12.994422] iwlwifi 0000:00:0c.0: Direct firmware load for
> iwlwifi-9260-th-b0-jf-b0-33.ucode failed with error -2
> [   12.994442] iwlwifi 0000:00:0c.0: Direct firmware load for
> iwlwifi-9260-th-b0-jf-b0-32.ucode failed with error -2
> [   12.994456] iwlwifi 0000:00:0c.0: Direct firmware load for
> iwlwifi-9260-th-b0-jf-b0-31.ucode failed with error -2
> [   12.994470] iwlwifi 0000:00:0c.0: Direct firmware load for
> iwlwifi-9260-th-b0-jf-b0-30.ucode failed with error -2
> [   12.994473] iwlwifi 0000:00:0c.0: no suitable firmware found!
> [   12.994477] iwlwifi 0000:00:0c.0: minimum version required:
> iwlwifi-9260-th-b0-jf-b0-30
> [   12.994479] iwlwifi 0000:00:0c.0: maximum version supported:
> iwlwifi-9260-th-b0-jf-b0-33
> 
> 
> 
> I'm not able to find these missing files in linux-firmware.git and
> any
> other possible place. What's the status of supporting this 9462NGW?
> Please let me know if any more information required. Thanks

Unfortunately we have not published the firmware for this NIC yet. 
I'll try to get an approval to publish it today (or latest by the end
of the week) and I'll let you know.

--
Cheers,
Luca.
