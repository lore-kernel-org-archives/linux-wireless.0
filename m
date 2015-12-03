Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37305 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbbLCID1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 03:03:27 -0500
Received: by wmww144 with SMTP id w144so10781616wmw.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2015 00:03:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87bna8f1si.fsf@kamboji.qca.qualcomm.com>
References: <87bna8f1si.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 3 Dec 2015 09:03:25 +0100
Message-ID: <CALhHN=pXxEvY4wZcaQ8EL9jNgCy-sC97RwiO7PgaNVfKEO1FGw@mail.gmail.com> (sfid-20151203_090413_916734_C3AB3C9F)
Subject: Re: wlan0: set_features() failed (-1); wanted 0x0000000000004008,
 left 0x0000000000004808
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 December 2015 at 08:07, Kalle Valo <kvalo@codeaurora.org> wrote:
> Hi,
>
> For few weeks (I think) I have seen these kind of messages:
>
> ath10k_pci 0000:02:00.0 wlan0: set_features() failed (-1); wanted 0x0000000000004008, left 0x0000000000004808
>
> iwlwifi 0000:03:00.0 wlan0: set_features() failed (-1); wanted 0x0000000000004000, left 0x0000000000004800
>
> I'm using ath.git master branch which is latest wireless-testing plus
> latest ath patches. Any ideas what's causing these? mac80211 or
> something else?
>
Missing:
net: fix feature changes on devices without ndo_set_features ?

BR
Janusz

> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
