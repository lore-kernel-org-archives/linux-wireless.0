Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:20140 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYB2NLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 08:11:20 -0500
Received: by wx-out-0506.google.com with SMTP id h31so4207040wxd.4
        for <linux-wireless@vger.kernel.org>; Fri, 29 Feb 2008 05:11:18 -0800 (PST)
Message-ID: <40f31dec0802290511i694755ecoed3ac2e38c030c7d@mail.gmail.com> (sfid-20080229_131130_826786_AA26B02E)
Date: Fri, 29 Feb 2008 15:11:17 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: ath5k on ARM
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <m3hcfum53k.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <m3hcfum53k.fsf@maximus.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/28, Krzysztof Halasa <khc@pm.waw.pl>:
> Hi,
>
>  Another thing:
>  ath5k uses udelay(2300). ARM has (include/asm-arm/delay.h):
>  #define MAX_UDELAY_MS 2
>
>  It ends up in __bad_udelay.
>
>  Solution?
>

Hmm, i'll see if it can work with smaller delay and let you know...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
