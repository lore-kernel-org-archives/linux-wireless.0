Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48938 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab3CGCGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 21:06:12 -0500
Received: by mail-lb0-f174.google.com with SMTP id l12so36417lbo.33
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2013 18:06:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20788.28891.721850.133032@gargle.gargle.HOWL>
References: <1362381201-9704-1-git-send-email-sujith@msujith.org>
 <1362381201-9704-2-git-send-email-sujith@msujith.org> <1907650.rOdA2c4Utl@bentobox>
 <20788.28891.721850.133032@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Wed, 6 Mar 2013 18:05:50 -0800
Message-ID: <CAB=NE6V5fCU1jgV8dUFYJhfox+2cGDeMjPLiGpG3JGEPMwxZTg@mail.gmail.com> (sfid-20130307_030616_508764_79C75771)
Subject: Re: [PATCH 2/2] initvals: Update AR9462 initvals
To: Sujith Manoharan <sujith@msujith.org>
Cc: Schrober <franzschrober@yahoo.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 4, 2013 at 2:00 AM, Sujith Manoharan <sujith@msujith.org> wrote:
> Schrober wrote:
>> Why? How it is helping? What it is doing? Does it require changes to the
>> driver? I cite
>>  http://linuxwireless.org/en/users/Drivers/ath9k_hw/initvals-tool
>>
>> "Note that initval changes are expected to have a respective equivalent *good*
>> commit log entry, so please don't simply send initval changes without some
>> sort of explanation, unless you just cannot find one."
>
> Unfortunately, this particular initvals update has no detailed information.
> This is the latest INI values for AR9462 which has been given to us by
> the internal systems team.

Sorry for the delay, thanks, applied and pushed!

 Luis
