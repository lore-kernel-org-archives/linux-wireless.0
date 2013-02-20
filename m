Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:38901 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933800Ab3BTOYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 09:24:17 -0500
Received: by mail-ie0-f177.google.com with SMTP id 16so9930777iea.22
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2013 06:24:17 -0800 (PST)
Date: Wed, 20 Feb 2013 09:24:01 -0500
From: Bob Copeland <me@bobcopeland.com>
To: devel@lists.open80211s.org
Cc: Adrian Chadd <adrian@freebsd.org>, ath9k-devel@lists.ath9k.org,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
Message-ID: <20130220142401.GA21725@localhost> (sfid-20130220_152425_948109_C25A89BF)
References: <alpine.DEB.2.02.1302191752110.31254@icf.org.ru>
 <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
 <alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
 <CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com>
 <20771.50338.434076.484711@gargle.gargle.HOWL>
 <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com>
 <20771.51233.248133.141840@gargle.gargle.HOWL>
 <alpine.DEB.2.02.1302192258510.19584@icf.org.ru>
 <CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com>
 <alpine.DEB.2.02.1302200027120.19533@icf.org.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.02.1302200027120.19533@icf.org.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2013 at 12:31:13AM +0400, Georgiewskiy Yuriy wrote:
> common.h
> #define ATH_EP_RND(x, mul)                                              \
>         ((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))

Hmm, is that the same as:

    (x + mul/2) / mul?

-- 
Bob Copeland %% www.bobcopeland.com
