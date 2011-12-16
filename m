Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1LPXck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 18:32:40 -0500
Received: by wgbdr13 with SMTP id dr13so7023084wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Dec 2011 15:32:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111216213307.GA5396@tuxdriver.com>
References: <1323871708-19852-1-git-send-email-linville@tuxdriver.com>
	<CACna6rwEfgxMcM1FQDLTWqsM3iy2NqokSAByU13oeT-XkysSzw@mail.gmail.com>
	<20111216213307.GA5396@tuxdriver.com>
Date: Sat, 17 Dec 2011 00:32:37 +0100
Message-ID: <CACna6rxKKE1f3+PnZb3aiKJuAOxe8O24OQPKHyT4cwJxU2OkwA@mail.gmail.com> (sfid-20111217_003244_524819_289AD982)
Subject: Re: [PATCH] b43: avoid calling bcma_* if CONFIG_B43_BCMA is not set
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 16 grudnia 2011 22:33 użytkownik John W. Linville
<linville@tuxdriver.com> napisał:
> On Thu, Dec 15, 2011 at 12:45:58PM +0100, Rafał Miłecki wrote:
>> 2011/12/14 John W. Linville <linville@tuxdriver.com>:
>> > Avoids this:
>> >
>> > ERROR: "bcma_chipco_pll_write" [drivers/net/wireless/b43/b43.ko] undefined!
>> >
>> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>
>> [BTW] Can you use b43-dev as CC in the future?
>
> Maybe you should update the MAINTAINERS entry so that
> scripts/get_maintainer.pl will find that?

Absolutely! I will, thanks.

-- 
Rafał
