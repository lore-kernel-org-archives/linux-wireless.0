Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37759 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbcDGMHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 08:07:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Alexander Tsoy <alexander@tsoy.me>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Andrea Merello <andrea.merello@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>, ath9k-devel@lists.ath9k.org,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
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
	linux-wireless@vger.kernel.org, Luciano Coelho <luca@coelho.fi>,
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
Date: Thu, 07 Apr 2016 15:07:41 +0300
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com> (Julian Calaby's
	message of "Fri, 18 Mar 2016 13:20:13 +1100")
Message-ID: <871t6h4o6q.fsf@purkki.adurom.net> (sfid-20160407_140821_748345_3D93DE65)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

> This is a set of all patches in patchwork which were pending when the 4.6
> merge window opened that meet the following criteria:
>
> 1. They're sane
> 2. They're either obviously correct, I can review them, or they've been
>    reviewed or ACK'd by someone else.
> 3. They don't require any code changes to make them applyable.
>
> That said, if anyone doesn't like any of these patches for any reason,
> just give me a reason and I'll drop it.
>
> I've split the pending patches into 4 sets as detailed below. All patches
> have been rebased to apply in order on wireless-drivers-next at
> wireless-drivers-next-for-davem-2016-03-14.

Thank you for working on this, this is very helpful.

I have deferred patch 14 and dropped patch 19[1], the rest I'm planning
to apply soon. I also tried to remove the original patches from deferred
queue by moving them to state "superseded", but I might missed
something.

[1] Oddly I cannot find patch 19 from patchwork, I don't know what
    happened to it. I do see it on the mailing list, though.

-- 
Kalle Valo
