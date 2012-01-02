Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46330 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2ABMlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 07:41:44 -0500
Received: by wgbdr13 with SMTP id dr13so26575800wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jan 2012 04:41:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120102122018.30057.qmail@stuge.se>
References: <1325490085-3806-1-git-send-email-zajec5@gmail.com>
	<1325490085-3806-2-git-send-email-zajec5@gmail.com>
	<20120102122018.30057.qmail@stuge.se>
Date: Mon, 2 Jan 2012 13:41:42 +0100
Message-ID: <CACna6rxiHydMmVOK18DO6X5COSUvZ+2c5=n-_oztBsP3NkxFhQ@mail.gmail.com> (sfid-20120102_134147_764697_DA9805CB)
Subject: Re: [PATCH 2/3] bcma: SPROM: add macro for easier extraction
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 2 stycznia 2012 13:20 użytkownik Peter Stuge <peter@stuge.se> napisał:
> Rafał Miłecki wrote:
>> +#define SPEX(_field, _offset, _mask, _shift) \
>> +     bus->sprom._field = ((sprom[SPOFF(_offset)] & (_mask)) >> (_shift))
>
> Maybe this should take at least bus as parameter too?

I also like the proposed solution because it let me fit some lines 80
chars length. See all the
SSB_SROM8_*_PA_[0-2]
from the next patch. Most of them are 80 char long ;)

-- 
Rafał
