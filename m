Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:63856 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXLGATR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 19:19:17 -0500
Received: by py-out-1112.google.com with SMTP id u77so1008431pyb
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2007 16:19:17 -0800 (PST)
Message-ID: <43e72e890712061619n6eca015fj9f2e4409c767547d@mail.gmail.com> (sfid-20071207_001921_136626_E6502FC9)
Date: Thu, 6 Dec 2007 19:19:16 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Automated kerneldoc for all wireless drivers
In-Reply-To: <43e72e890712061542g7ff7d2adl399eb3c977041120@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890712061538k10d806f8xbb7148b0de3f66ce@mail.gmail.com>
	 <43e72e890712061542g7ff7d2adl399eb3c977041120@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 6, 2007 6:42 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Dec 6, 2007 6:38 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> >   3910 total
>
> Sorry, I forgot the iwlwifi drivers:
>
>    670 iwlwifiiwl3945-basec-doc.html
>    325 iwlwifiiwl-3945c-doc.html
>    134 iwlwifiiwl-3945-commandsh-doc.html
>      0 iwlwifiiwl-3945-debugh-doc.html
>    121 iwlwifiiwl-3945h-doc.html
>      0 iwlwifiiwl-3945-hwh-doc.html
>      0 iwlwifiiwl-3945-ioh-doc.html
>     78 iwlwifiiwl-3945-rsc-doc.html
>     65 iwlwifiiwl-3945-rsh-doc.html
>    715 iwlwifiiwl4965-basec-doc.html
>    438 iwlwifiiwl-4965c-doc.html
>    422 iwlwifiiwl-4965-commandsh-doc.html
>      0 iwlwifiiwl-4965-debugh-doc.html
>    171 iwlwifiiwl-4965h-doc.html
>    566 iwlwifiiwl-4965-hwh-doc.html
>      0 iwlwifiiwl-4965-ioh-doc.html
>     69 iwlwifiiwl-4965-rsc-doc.html
>     65 iwlwifiiwl-4965-rsh-doc.html
>     54 iwlwifiiwl-helpersh-doc.html
>    119 iwlwifiiwl-prphh-doc.html
>      0 iwlwifiiwl-spectrumh-doc.html
>   4012 total
>
> For a total of 7922 for us now. Thanks Intel, great job!
>
>   Luis
>


Also, forgot to mention, if you want to see your kerneldoc warnings
you can add page with something like:

If this page is empty it means there are no kerneldoc warnings

<<kerneldocwarn(ath5k/ath5k.h)>>
