Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57784 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbcEMMjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2016 08:39:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Andreas Ziegler <andreas.ziegler@fau.de>,
	b43-dev <b43-dev@lists.infradead.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Use of deleted Kconfig option B43_PCMCIA
References: <56A78B69.9050002@fau.de>
	<CACna6rzdCwK7cWNkHUFbeaG2DkOW8bKfxEv=RqhW7RPZsv84hg@mail.gmail.com>
Date: Fri, 13 May 2016 15:39:17 +0300
In-Reply-To: <CACna6rzdCwK7cWNkHUFbeaG2DkOW8bKfxEv=RqhW7RPZsv84hg@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Tue, 26 Jan 2016
 16:35:09 +0100")
Message-ID: <87oa8ap1xm.fsf@purkki.adurom.net> (sfid-20160513_143944_866117_83B50B61)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding linux-wireless)

Rafał Miłecki <zajec5@gmail.com> writes:

> On 26 January 2016 at 16:06, Andreas Ziegler <andreas.ziegler@fau.de> wrote:
>> your commit 399500da18f7 ("ssb: pick PCMCIA host code support from b43
>> driver") removed the Kconfig option B43_PCMCIA from Kconfig, but left
>> one reference to it in b43/main.c, inside the b43_print_driverinfo()
>> function.
>>
>> Can this #ifdef be removed, should it be replaced with an #ifdef using
>> CONFIG_SSB_PCMCIAHOST instead or should we do something entirely different?
>
> We even got patch for this, but it wasn't submitted correctly (didn't
> go to linux-wireless):
> https://lkml.org/lkml/2015/11/2/154

Nobody resubmitted that patch?

-- 
Kalle Valo
