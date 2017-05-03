Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:58390 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdECPCR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 11:02:17 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCHv2 0/4] Motorola Droid 4: Add WL1285C support
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAL_JsqKktwFmxXijB0FVVoWGkswXm3twzD7She7zGR=rVQ4hWA@mail.gmail.com>
Date: Wed, 3 May 2017 17:02:13 +0200
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <F455FC62-BA1C-4A59-B526-DDB90362CFE8@holtmann.org> (sfid-20170503_170231_134316_CE54656F)
References: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
 <CAL_JsqKktwFmxXijB0FVVoWGkswXm3twzD7She7zGR=rVQ4hWA@mail.gmail.com>
To: Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rob,

>> Motorola Droid 4 uses a WL1285C, as visible on iFixit [0]. This
>> fixes the DT file to use correct compatible for the wifi node
>> and adds the bluetooth node.
>> 
>> [0] https://www.ifixit.com/Teardown/Motorola+Droid+4+Teardown/7759#s31961
>> 
>> Changes to PATCHv1:
>> - use proper compatible value for bluetooth / shared transport
>> - add patches fixing wlcore compatible for Droid 4
>> 
>> -- Sebastian
>> 
>> Sebastian Reichel (4):
>>  wlcore: add wl1285 compatible
>>  ARM: dts: omap4-droid4: Use wl1285 for wifi compatible
>>  Bluetooth: hci_ll: Add compatible values for more WL chips
>>  ARM: dts: omap4-droid4: Add bluetooth
> 
> For the series,
> 
> Reviewed-by: Rob Herring <robh@kernel.org>

so now the question is if we merge this through a single maintainer or have each maintainer take the pieces? I would almost suggest that Dave Miller takes this directly into net-next to make this smoother.

Regards

Marcel
