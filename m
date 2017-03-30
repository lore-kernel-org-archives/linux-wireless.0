Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:49982 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933196AbdC3IEO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 04:04:14 -0400
Date: Thu, 30 Mar 2017 09:07:39 +0200
From: Bastian Bittorf <bb@npl.de>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Tim Harvey <tharvey@gateworks.com>, linux-wireless@vger.kernel.org,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [RESEND] ath9k failure to authenticate WPA2 client mode
Message-ID: <20170330070739.GF21227@medion.lan> (sfid-20170330_100420_581692_BDE77AFB)
References: <CAJ+vNU0gsjJvF34eQFQ48TLHv-t1H8W75R1+FkOzN76-K_N8Rw@mail.gmail.com>
 <CALhHN=oKYS=RRcJ1n2=Se8c0ce1OtYy3LNhmz-DT8EDT+QSSWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALhHN=oKYS=RRcJ1n2=Se8c0ce1OtYy3LNhmz-DT8EDT+QSSWQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Janusz Dziedzic <janusz.dziedzic@tieto.com> [30.03.2017 08:26]:
> On 29 March 2017 at 19:03, Tim Harvey <tharvey@gateworks.com> wrote:
> > I don't know when ath9k last worked honestly. I usually use them under
> > OpenWrt which has its own patches against periodic updates of linux
> > backports. I noticed this first with Ubuntu 16.04 with the Ubuntu 4.4
> > kernel, saw it still with the Ubuntu 4.8 kernel, then repeated the
> > issue in wireless-next.
> >
> > Any ideas?
> >
> Interesting. Are you sure wlan0 is ath9k and wlan1 is ath10k?

an easy check for that is:

# root@box:~ DEV=wlan0; basename $(readlink /sys/class/net/$DEV/device/driver)
iwlwifi

# output is e.g. ath10k_pci or ath9k

bye, bastian
