Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753479AbeDPNso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:48:44 -0400
Received: from mail-qt0-f174.google.com (mail-qt0-f174.google.com [209.85.216.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32CD5217DF
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 13:48:44 +0000 (UTC)
Received: by mail-qt0-f174.google.com with SMTP id d3so15300372qth.8
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 06:48:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKzrAgSbYN1znJi8qM0QEfCniw2AGEKnrh-vJcUcXW0rVmo9tQ@mail.gmail.com>
References: <CAKzrAgSbYN1znJi8qM0QEfCniw2AGEKnrh-vJcUcXW0rVmo9tQ@mail.gmail.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Mon, 16 Apr 2018 09:48:42 -0400
Message-ID: <CA+5PVA6nkGMzQHVu8LSaOUGU0h16rMeQvPoNORtyAzp8YDidOw@mail.gmail.com> (sfid-20180416_154848_320247_586EFFD8)
Subject: Re: Compex WLE1216V2-20 (QCA9984) firmware is missing
To: "ojab //" <ojab@ojab.ru>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Linux Firmware <linux-firmware@kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 27, 2018 at 12:41 PM, ojab // <ojab@ojab.ru> wrote:
> [please CC me since I'm not subscribed to the lists and terribly sorry
> for HTML mails]
>
> Oh hai!
>
> I have Compex WLE1216V2-20 (based on QCA9984 chip) that isn't
> supported by linux-firmware (git master), card init fails with
>
>>[Mon Mar 26 17:18:47 2018] ath10k_pci 0000:05:00.0: failed to fetch board data for bus=pci,bmi-chip-id=0,bmi-board-id=30 from ath10k/QCA9984/hw1.0/board-2.bin
>
> It works fine with board-2.bin from the compex website [1] (can be
> downloaded directly from
> https://bugzilla.kernel.org/attachment.cgi?id=274959).
> What should be done to have it upstreamed?

This is likely a question for Kalle.  I would expect an update to the
existing board-2.bin file submitted through Qualcomm with support for
that device.

josh

>
> [1] https://downloads.compex.com.sg/?dir=uploads/boardData/For_Building_New_Firmware
>
> //wbr ojab
