Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:46654 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbeAUW4J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Jan 2018 17:56:09 -0500
Received: by mail-ua0-f170.google.com with SMTP id j23so4636207uak.13
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jan 2018 14:56:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <14c5f7f4-0d5b-cecd-b45b-3672b67da07a@gmail.com>
References: <CAL9uMOFT3VwqHs5+wvot+dxArvhd7Bi-U5+CKhYUXjYwHcU=jg@mail.gmail.com>
 <20180111103006.GA17574@thinktank.home.org> <14c5f7f4-0d5b-cecd-b45b-3672b67da07a@gmail.com>
From: Carlo Caione <carlo@endlessm.com>
Date: Sun, 21 Jan 2018 22:56:08 +0000
Message-ID: <CAL9uMOG77it=kqkbjryPVpY2eVJqqjedVeAhdxqpZM6Z8JWuiA@mail.gmail.com> (sfid-20180121_235842_723814_EE24EF1E)
Subject: Re: RTL8723bu: poor signal and connection troubles
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Barry Day <briselec@gmail.com>, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org,
        mylene.josserand@free-electrons.com,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 21, 2018 at 9:46 PM, Jes Sorensen <jes.sorensen@gmail.com> wrote:
> On 01/11/2018 05:30 AM, Barry Day wrote:

> One issue with rtl8723bu is that it needs to coexist with the bluetooth
> driver. When I wrote the rtl8723bu support that was no BT support for
> the chip in the kernel and it worked fine, at least for me. However if
> you load the BT driver for the dongle which someone pushed into the
> kernel since then, it is likely to hijack the antennas causing the weak
> signal you describe.

Yeah, that's why when testing the dongle I carefully disabled BT and
made sure no BT driver was probed at all. Still I can see the issue.
I honestly doubt that the problem is caused by BT coexistence. Any
other idea or suggestion to debug this problem?

Thanks,

-- 
Carlo Caione  |  +44.7384.69.16.04  |  Endless
