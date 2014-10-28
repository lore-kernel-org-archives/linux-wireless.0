Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:42629 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaJ1HIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 03:08:25 -0400
Received: by mail-yh0-f53.google.com with SMTP id z6so29002yhz.12
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2014 00:08:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141027180436.GE28300@tuxdriver.com>
References: <1413932631-12866-1-git-send-email-ryazanov.s.a@gmail.com>
 <1413932631-12866-12-git-send-email-ryazanov.s.a@gmail.com> <20141027180436.GE28300@tuxdriver.com>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Tue, 28 Oct 2014 11:08:04 +0400
Message-ID: <CAHNKnsTWvZy=-TBv-KPjCOD-vhwcxUUGv61doYUm0F77if-pqw@mail.gmail.com> (sfid-20141028_080834_461834_85C62D11)
Subject: Re: [PATCH v2 11/13] ath5k: revert AHB bus support removing
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
	Linux MIPS <linux-mips@linux-mips.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-10-27 21:04 GMT+03:00 John W. Linville <linville@tuxdriver.com>:
> On Wed, Oct 22, 2014 at 03:03:49AM +0400, Sergey Ryazanov wrote:
>> This reverts commit 093ec3c5337434f40d77c1af06c139da3e5ba6dc.
>>
>> AHB bus code has been removed, since we did not have support Atheros
>> AR231x SoC, required for building the AHB version of ath5k. Now that
>> support WiSoC chips added we can restore functionality back.
>>
>> Singed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>> Cc: Jiri Slaby <jirislaby@gmail.com>
>> Cc: Nick Kossifidis <mickflemm@gmail.com>
>> Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: ath5k-devel@lists.ath5k.org
>
> Acked-by: John W. Linville <linville@tuxdriver.com>
>
John, should I include these two patches in v3 or you already merge
them in your tree?

-- 
BR,
Sergey
