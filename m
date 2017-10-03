Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blatinox.fr ([51.254.120.209]:41817 "EHLO vps202351.ovh.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751250AbdJCBid (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 21:38:33 -0400
Date: Mon, 2 Oct 2017 21:22:14 -0400
From: =?UTF-8?B?SsOpcsOpbXk=?= Lefaure <jeremy.lefaure@lse.epita.fr>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Sathya Perla <sathya.perla@broadcom.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, USB <linux-usb@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com
Subject: Re: [PATCH 05/18] net: use ARRAY_SIZE
Message-ID: <20171002212214.30d7013a@blatinox-laptop.localdomain> (sfid-20171003_033846_353042_AD7A294F)
In-Reply-To: <CAHp75VfC2e+h8GCiB-1Rbe=_z3siBBo0WfqEf3qz8yWh8Cm3RQ@mail.gmail.com>
References: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr>
        <20171001193101.8898-6-jeremy.lefaure@lse.epita.fr>
        <CAHp75VfC2e+h8GCiB-1Rbe=_z3siBBo0WfqEf3qz8yWh8Cm3RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2 Oct 2017 16:07:36 +0300
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> > +       {&gainctrl_lut_core0_rev0, ARRAY_SIZE(gainctrl_lut_core0_rev0), 26, 192,
> > +        32},  
> 
> For all such cases I would rather put on one line disregard checkpatch
> warning for better readability.
I agree that it would be better. I didn't know that it was possible to
not follow this rule for anything else than a string.

I am waiting for more comments and I will send a v2.

Thank you,
Jérémy
