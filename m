Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:40012 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751622AbeDOPMq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Apr 2018 11:12:46 -0400
Received: by mail-ua0-f172.google.com with SMTP id n20so8557259ual.7
        for <linux-wireless@vger.kernel.org>; Sun, 15 Apr 2018 08:12:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKzrAgSbYN1znJi8qM0QEfCniw2AGEKnrh-vJcUcXW0rVmo9tQ@mail.gmail.com>
References: <CAKzrAgSbYN1znJi8qM0QEfCniw2AGEKnrh-vJcUcXW0rVmo9tQ@mail.gmail.com>
From: "ojab //" <ojab@ojab.ru>
Date: Sun, 15 Apr 2018 15:12:45 +0000
Message-ID: <CAKzrAgQ5iTMo1eWcL_0Os_Ce-67mMfMyJy9Gx7tCDcZO8zWv0w@mail.gmail.com> (sfid-20180415_171251_730820_F19FDF28)
Subject: Re: Compex WLE1216V2-20 (QCA9984) firmware is missing
To: linux-wireless@vger.kernel.org, linux-firmware@kernel.org,
        kvalo@qca.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gentle ping.

//wbr ojab

On Tue, Mar 27, 2018 at 4:41 PM, ojab // <ojab@ojab.ru> wrote:
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
>
> [1] https://downloads.compex.com.sg/?dir=uploads/boardData/For_Building_New_Firmware
>
> //wbr ojab
