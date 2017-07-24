Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33583 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753939AbdGXNis (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 09:38:48 -0400
Received: by mail-oi0-f45.google.com with SMTP id a9so24353918oih.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 06:38:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b91c5424-baaf-c1e1-5d2b-51aad79b6991@rempel-privat.de>
References: <CAH3WNGT-tYhUr3sTD8gfeUDQQ4ihtVccqEFUAEfxU6q5Ro3wxg@mail.gmail.com>
 <77ba0bc6-f57d-013c-9523-b9d4b2eaa102@rempel-privat.de> <CAH3WNGQwXVQM9pMA-g_yFc3apb__aUxA1pir75LwifV7pgTA=g@mail.gmail.com>
 <b91c5424-baaf-c1e1-5d2b-51aad79b6991@rempel-privat.de>
From: Arul jothi <aruljkp@gmail.com>
Date: Mon, 24 Jul 2017 21:38:07 +0800
Message-ID: <CAH3WNGSszHfaidOTo3xwsP2HU_C5A4ff0pisqaJxj_Q4+ZK-VQ@mail.gmail.com> (sfid-20170724_153946_349846_2FF94E68)
Subject: Re: Madwifi porting to Ath9k
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can someone from Atheros confirm that PCF is supported in AR9344 /
9342 hardware.
I doubt, PCF might not work without hardware support.

On Mon, Jul 24, 2017 at 3:19 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 24.07.2017 um 08:08 schrieb Arul jothi:
>> Hi Oleksij,
>>
>>    Thanks for your reply. I am new to the linux wireless.
>> Does ath9k has support for PCF implementation ? I couldn't find any
>> reference about PCF in ath9k.
>>
>> Do you mean porting madwifi code to ath9k is straight forward ?.
>> Please give some link or guideliness.
>
> - Isolate PCF code in Madwifi
> - port it to the ath9k if possible
> - do lots of testing
> - send patches for review.
>
> --
> Regards,
> Oleksij
>
