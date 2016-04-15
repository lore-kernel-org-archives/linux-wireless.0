Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33597 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbcDOLxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 07:53:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Alexander Tsoy <alexander@tsoy.me>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Andrea Merello <andrea.merello@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>, ath9k-devel@lists.ath9k.org,
	b43-dev <b43-dev@lists.infradead.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Byeoungwook Kim <quddnr145@gmail.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Colin Ian King <colin.king@canonical.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Eyal Reizer <eyalreizer@gmail.com>,
	Franky Lin <frankyl@broadcom.com>,
	Geliang Tang <geliangtang@163.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Ivan Safonov <insafonov@gmail.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luca@coelho.fi>,
	Luis Felipe Dominguez Vega <lfdominguez@nauta.cu>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Miaoqing Pan <miaoqing@codeaurora.org>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Nicolas Pitre <nico@linaro.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Sara Sharon <sarasharon1@gmail.com>,
	Shahar Patury <shaharp@ti.com>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 00/19] Pending Cleanup patches for 4.7
References: <cover.1458262312.git.julian.calaby@gmail.com>
	<871t6h4o6q.fsf@purkki.adurom.net> <87pou11ikg.fsf@purkki.adurom.net>
	<CAGRGNgUiREy2WsSD6iRZ+annBYv+dGgMWvASb=Y5+eT4gJYE_A@mail.gmail.com>
Date: Fri, 15 Apr 2016 14:53:20 +0300
In-Reply-To: <CAGRGNgUiREy2WsSD6iRZ+annBYv+dGgMWvASb=Y5+eT4gJYE_A@mail.gmail.com>
	(Julian Calaby's message of "Fri, 8 Apr 2016 10:56:22 +1000")
Message-ID: <87mvovqea7.fsf@kamboji.qca.qualcomm.com> (sfid-20160415_135340_608636_6E1F1720)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

>>> [1] Oddly I cannot find patch 19 from patchwork, I don't know what
>>>     happened to it. I do see it on the mailing list, though.
>>
>> Actually another nacked patch 16 also has disappeared from patchwork, so
>> I'm not going to apply that either. I'm starting to wonder that maybe
>> you removed these yourself from patchwork?
>
> I did do that: I updated both to "Rejected" when people NACKed them.
>
> Should I not have done that? I thought I was making things easier for you.

That does help, but I started to wonder what happened to them (did I do
something wrong etc) before I realised that you actually dropped them
yourself. Patchwork is sometimes a bit clumsy like this, so maybe an
email reply like "dropping these from patchwork" or similar is a good
idea?

-- 
Kalle Valo
