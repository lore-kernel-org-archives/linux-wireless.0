Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr720059.outbound.protection.outlook.com ([40.107.72.59]:15116
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752515AbeF2J1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 05:27:09 -0400
Date: Fri, 29 Jun 2018 12:26:56 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [1/6] qtnfmac: implement net_device_ops callback to set MAC
 address
Message-ID: <20180629092654.shzir2mfmlp5luf5@bars> (sfid-20180629_112715_942571_3A249DFF)
References: <20180531091102.28666-2-sergey.matyukevich.os@quantenna.com>
 <20180627155439.481E76034E@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180627155439.481E76034E@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:
> 
> > From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> >
> > Implement net_device_ops::ndo_set_mac_address callback to allow for
> > setting interface MAC address. Implementation is done through existing
> > CHANGE_INTF firmware command. All validation is to be done by firmware.
> >
> > Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> 2 patches applied to wireless-drivers-next.git, thanks.
> 
> ed9f34bb9d33 qtnfmac: implement net_device_ops callback to set MAC address
> 6fbef9540af0 qtnfmac: enable source MAC address randomization support

Hello Kalle,

I see the other 4 patches in this series are in 'Deferred' state. Could you
please clarify what that means. Do you have any concerns about those
remaining patches or any actions are needed from our side ?

Regards,
Sergey
