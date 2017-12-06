Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:33975 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752690AbdLFHNi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Dec 2017 02:13:38 -0500
MIME-Version: 1.0
In-Reply-To: <1512490314.4977.143.camel@synopsys.com>
References: <1512490314.4977.143.camel@synopsys.com>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Wed, 6 Dec 2017 12:43:36 +0530
Message-ID: <CAEhWJF=1GU9vOj5+DeJCOjbbh4zh_OMyv2HKH_1XT3XP2auFUg@mail.gmail.com> (sfid-20171206_081342_868259_542654D5)
Subject: Re: rsi_91x: Failed to read status register on failed authentication
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: "amit.karwar@redpinesignals.com" <amit.karwar@redpinesignals.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-snps-arc@lists.infradead.org"
        <linux-snps-arc@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 5, 2017 at 9:41 PM, Alexey Brodkin
<Alexey.Brodkin@synopsys.com> wrote:
> Hi Amit,
>
> I'm seeing quite a strange behavior of RedPine module.
> It connects perfectly fine to one of access points but fails
> to connect to another.
>
> Moreover after that failure RSI driver starts to flood me with
> messages saying:
> --------------------->8--------------------
> rsi_91x: rsi_sdio_check_buffer_status: Failed to read status register
> --------------------->8--------------------
>
> Below you may find details of my 2 experiments.
> Note I use vanilla Linux kernel v4.14.4
>
> Any ideas what could be wrong?
>

Could you enable driver debug zones and share dmesg log for analysis?

echo 0xffffffff > /sys/kernel/debug/phy0/debug_zone

Regards,
Amitkumar
