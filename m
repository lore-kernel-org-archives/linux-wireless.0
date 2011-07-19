Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49040 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1GSUyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 16:54:33 -0400
Received: by pzk3 with SMTP id 3so5442174pzk.5
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 13:54:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rxZMFnFiYFkrW9xTkL_eXTXH91sEO-W=HZqoiUYLMNumQ@mail.gmail.com>
References: <1310857566-2876-1-git-send-email-zajec5@gmail.com>
	<1310857566-2876-2-git-send-email-zajec5@gmail.com>
	<20110719204246.GB2477@tuxdriver.com>
	<CACna6rxZMFnFiYFkrW9xTkL_eXTXH91sEO-W=HZqoiUYLMNumQ@mail.gmail.com>
Date: Tue, 19 Jul 2011 22:54:32 +0200
Message-ID: <CACna6rwCNyOKN+gHESX6Qt7uKQNuPWBrsyTJ1rWzjXMULV5y6Q@mail.gmail.com> (sfid-20110719_225436_796029_297AAF8A)
Subject: Re: [PATCH 2/4] bcma: allow setting FAST clockmode for a core
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 19 lipca 2011 22:50 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> W dniu 19 lipca 2011 22:42 użytkownik John W. Linville
> <linville@tuxdriver.com> napisał:
>>  CC [M]  drivers/bcma/core.o
>> drivers/bcma/core.c: In function ‘bcma_core_set_clockmode’:
>> drivers/bcma/core.c:65:22: error: ‘BCMA_CLKCTLST’ undeclared (first use in this function)
>> drivers/bcma/core.c:65:22: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/bcma/core.c:65:73: error: ‘BCMA_CLKCTLST_FORCEHT’ undeclared (first use in this function)
>> drivers/bcma/core.c:69:8: error: ‘BCMA_CLKCTLST_HAVEHT’ undeclared (first use in this function)
>> drivers/bcma/core.c: In function ‘bcma_core_pll_ctl’:
>> drivers/bcma/core.c:89:35: error: ‘BCMA_CLKCTLST_EXTRESREQ’ undeclared (first use in this function)
>> drivers/bcma/core.c:90:38: error: ‘BCMA_CLKCTLST_EXTRESST’ undeclared (first use in this function)
>> drivers/bcma/core.c:93:22: error: ‘BCMA_CLKCTLST’ undeclared (first use in this function)
>> make[2]: *** [drivers/bcma/core.o] Error 1
>> make[1]: *** [drivers/bcma] Error 2
>> make: *** [drivers] Error 2
>
> I'm sorry, that's quite normal you could lost order&dependency with
> the amount of patches I've sent.
>
> As nobody objected, please apply
> [RFC][PATCH] bcma: move define of BCMA_CLKCTLST register
> It should be applied before this one.

Could I do something to avoid such a problems in the future?

Should I put info about dependency in cover-letter? Should I create
own git tree? Should I slow down with sending patches (doing more of
them before sending)?

-- 
Rafał
