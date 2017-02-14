Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36587 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752155AbdBNWGN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 17:06:13 -0500
Received: by mail-oi0-f65.google.com with SMTP id u143so2459688oif.3
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 14:06:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170214220346.10479-1-zajec5@gmail.com>
References: <20170214220346.10479-1-zajec5@gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 14 Feb 2017 23:06:07 +0100
Message-ID: <CACna6rxv1AngN2Y5J6WFgE+svRcMXVWQ_r-JpGFh2no9a6zpMA@mail.gmail.com> (sfid-20170214_230651_866719_ADBA8A5D)
Subject: Re: [PATCH] bcma: gpio: set of_node regardless of the host type
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 February 2017 at 23:03, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> DT allows describing many device types, not only platform ones. If e.g.
> bcma is hosted on PCI(e) and it has its of_node, let's pass it to the
> GPIO subsystem. This allows GPIO code to handle more hardware details
> not only for bcma on a SoC.
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>

This obviously can wait for 4.12 merge window, no rush.
