Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0078.outbound.protection.outlook.com ([104.47.37.78]:55776
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754720AbeF2MDw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 08:03:52 -0400
Date: Fri, 29 Jun 2018 15:03:38 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [1/6] qtnfmac: implement net_device_ops callback to set MAC
 address
Message-ID: <20180629120337.kcwa4vf7ycdihzqq@bars> (sfid-20180629_140356_684032_830B7EFF)
References: <20180531091102.28666-2-sergey.matyukevich.os@quantenna.com>
 <20180627155439.481E76034E@smtp.codeaurora.org>
 <20180629092654.shzir2mfmlp5luf5@bars>
 <87d0waexm2.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87d0waexm2.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
> 
> >> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:
> >>
> >> > From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> >> >
> >> > Implement net_device_ops::ndo_set_mac_address callback to allow for
> >> > setting interface MAC address. Implementation is done through existing
> >> > CHANGE_INTF firmware command. All validation is to be done by firmware.
> >> >
> >> > Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> >>
> >> 2 patches applied to wireless-drivers-next.git, thanks.
> >>
> >> ed9f34bb9d33 qtnfmac: implement net_device_ops callback to set MAC address
> >> 6fbef9540af0 qtnfmac: enable source MAC address randomization support
> >
> > Hello Kalle,
> >
> > I see the other 4 patches in this series are in 'Deferred' state. Could you
> > please clarify what that means. Do you have any concerns about those
> > remaining patches or any actions are needed from our side ?
> 
> I saw there was a comment on one patch and other patch used vendor
> commands which I need to review carefully. I didn't have time at the
> time so I put them to deferred and try to get back soon.

Ok, understood.

Regards,
Sergey
