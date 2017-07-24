Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36480 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752717AbdGXGJX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 02:09:23 -0400
Received: by mail-oi0-f49.google.com with SMTP id g131so17272555oic.3
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jul 2017 23:09:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <77ba0bc6-f57d-013c-9523-b9d4b2eaa102@rempel-privat.de>
References: <CAH3WNGT-tYhUr3sTD8gfeUDQQ4ihtVccqEFUAEfxU6q5Ro3wxg@mail.gmail.com>
 <77ba0bc6-f57d-013c-9523-b9d4b2eaa102@rempel-privat.de>
From: Arul jothi <aruljkp@gmail.com>
Date: Mon, 24 Jul 2017 14:08:42 +0800
Message-ID: <CAH3WNGQwXVQM9pMA-g_yFc3apb__aUxA1pir75LwifV7pgTA=g@mail.gmail.com> (sfid-20170724_080927_241536_C2BBAEAB)
Subject: Re: Madwifi porting to Ath9k
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oleksij,

   Thanks for your reply. I am new to the linux wireless.
Does ath9k has support for PCF implementation ? I couldn't find any
reference about PCF in ath9k.

Do you mean porting madwifi code to ath9k is straight forward ?.
Please give some link or guideliness.

Regards,
Arul.

On Mon, Jul 24, 2017 at 2:01 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 23.07.2017 um 15:54 schrieb Arul jothi:
>> Hi,
>>
>>   I have AR7161 based board which is using customized madwifi driver
>> with PCF implementation.
>> I need to port the driver to new board based on AR9344.
>> What should be the approach I should take
>>
>> 1.       Build Madwifi with current AR9344 Openwrt build
>>
>> 2.       Implement PCF with current Ath9k driver.
>>
>>
>> Please advise which approach I should take. Can someone help me with
>> some clue on that.
>> Thanks in advance.
>
> In long term it is preferable to extend upstream version of the driver
> (ath9k) aaand upstream you patches as well.
>
> ath9k has big developer community and good testing coverage.
>
> --
> Regards,
> Oleksij
>
