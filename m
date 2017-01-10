Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:34594 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759475AbdAJIfa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2017 03:35:30 -0500
Received: by mail-yw0-f195.google.com with SMTP id a10so13027794ywa.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2017 00:35:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC8mBSUHhwjdWAduhGt4qarV139JW2ERC-8CvRXAM3eMxvBLuA@mail.gmail.com>
References: <CAC8mBSUHhwjdWAduhGt4qarV139JW2ERC-8CvRXAM3eMxvBLuA@mail.gmail.com>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Tue, 10 Jan 2017 11:35:09 +0300
Message-ID: <CAHNKnsSriTXASs+qieBPk-2vEk4gT7QniVCjRzPi80=bm522XQ@mail.gmail.com> (sfid-20170110_093534_169306_6AA793C7)
Subject: Re: [ath5k-devel] ath5k keep-alive
To: =?UTF-8?Q?Denis_Peri=C5=A1a?= <denis@denis.in>
Cc: "open list:ATHEROS ATH5K WIR..." <ath5k-devel@lists.ath5k.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Denis.

CC linux-wireless since ath5k-devel not so active for a long time.

On Tue, Sep 13, 2016 at 10:30 AM, Denis Peri=C5=A1a <denis@denis.in> wrote:
> I have issue with frequent disconnects so I have to add watchdog scripts =
in
> cron which is really pain in..
> Is there any chance I can add some code to keep alive connection?

Did you try to use wpa_supplicant? It could take care about reconnection.

--=20
Sergey
