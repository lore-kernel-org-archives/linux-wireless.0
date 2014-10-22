Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:52821 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049AbaJVMiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 08:38:08 -0400
Received: by mail-yh0-f52.google.com with SMTP id f10so3314721yha.25
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 05:38:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141022121824.GA19113@localhost>
References: <1413932631-12866-1-git-send-email-ryazanov.s.a@gmail.com>
 <1413932631-12866-12-git-send-email-ryazanov.s.a@gmail.com> <20141022121824.GA19113@localhost>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Wed, 22 Oct 2014 16:37:46 +0400
Message-ID: <CAHNKnsT4g_yYOA6DnuvmRbR-xbAGUsdzWV8Bik62f+xtt=Vy4g@mail.gmail.com> (sfid-20141022_143812_464049_EBF9E30F)
Subject: Re: [PATCH v2 11/13] ath5k: revert AHB bus support removing
To: Bob Copeland <me@bobcopeland.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
	Linux MIPS <linux-mips@linux-mips.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"open list:ATHEROS ATH5K WIR..." <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-10-22 16:18 GMT+04:00 Bob Copeland <me@bobcopeland.com>:
> On Wed, Oct 22, 2014 at 03:03:49AM +0400, Sergey Ryazanov wrote:
>> This reverts commit 093ec3c5337434f40d77c1af06c139da3e5ba6dc.
>>
>> AHB bus code has been removed, since we did not have support Atheros
>> AR231x SoC, required for building the AHB version of ath5k. Now that
>> support WiSoC chips added we can restore functionality back.
>>
>> Singed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>   ^^^^^^
>
> Please keep the patches away from the stove! (SCNR)
>
I will send the healthy patch in v3!

-- 
BR,
Sergey
