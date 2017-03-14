Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:45397 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbdCNXP6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 19:15:58 -0400
To: Daniel Drake <drake@endlessm.com>, qca_merez@qca.qualcomm.com,
        wil6210@qca.qualcomm.com
References: <CAD8Lp45k01+rN8RXdvPthEDeJj7p-a-Lk5A1AQWXJBGezxQpaA@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>,
        Chris Chiu <chiu@endlessm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <0651bd85-656c-1156-b2e6-655f7649b8fe@dd-wrt.com> (sfid-20170315_001601_893509_E7704B90)
Date: Wed, 15 Mar 2017 00:15:53 +0100
MIME-Version: 1.0
In-Reply-To: <CAD8Lp45k01+rN8RXdvPthEDeJj7p-a-Lk5A1AQWXJBGezxQpaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: Where is wil6210.fw / wil6210.brd?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 14.03.2017 um 22:55 schrieb Daniel Drake:
> Hi,
>
> We are working with a new consumer laptop model that includes a
> wil6210 wireless adapter.
>
> It is not usable on current Linux distros because the firmware is not
> present. It's not in linux-firmware and we can't even find any
> download links when searching the web.
>
> Could you please send a copy of the required firmware to linux-firmware?
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
die firmware is only available from qca direct. but i could give you a 
hint. download the gpl source of the netgear r9000 model. it includes 
this firmware files
for anything else you need a sla/nda with qca
>
> Thanks
> Daniel
>


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
