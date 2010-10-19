Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42736 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0JSQ71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 12:59:27 -0400
Received: by gwj19 with SMTP id 19so47280gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Oct 2010 09:59:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <782419.6815.qm@web56803.mail.re3.yahoo.com>
References: <AANLkTimoMhytXWm9qh21VGX5B6EoE6JwWyMu1t-ivno9@mail.gmail.com> <782419.6815.qm@web56803.mail.re3.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 Oct 2010 09:59:06 -0700
Message-ID: <AANLkTimp7fdHWm370A7Bq+XmCcLzMu9mo8wyB5urxe2O@mail.gmail.com>
Subject: Re: [PATCH] Do not compile staging directory for bt target.
 Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: Bala Shanmugam <sbalashanmugam@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 19, 2010 at 6:35 AM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
>
>> Applied, you may want a
>
>>
>>   Luis
> I was just about to submit exactly the same patch :)
>
> BTW,  I was thinking, perhaps we could merge bt and ethernet drivers in one line, by two separate groups via driver-select. For example:
> Replace current:
> "Supported Ethernet drivers: < atl1 atl2 atl1e atl1c >"
> with
> "Supported Ethernet & Bluetooth drivers: < bt | eth (atlxx) >
>
> or something like that. This will notify users they can actually install bt drivers /if they don't read documentation/.
>
> Its a little weird that, atlxx are provided via driver-select and bt from 'make bt'. I believe they should be "on the same page"

Agreed.

> I would also suggest we drop the load.sh and wlload.sh scripts. I can't think of a reason why a sane person would opt for such iffy, redundant and probably malignant way to load their respective driver.
>
> There was something else, but I can't remember now ;)

Agreed.

  Luis
