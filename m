Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:43204 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaAPNjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 08:39:52 -0500
Received: by mail-bk0-f41.google.com with SMTP id u12so1033071bkz.0
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 05:39:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ppnst7jl.fsf@kamboji.qca.qualcomm.com>
References: <20140116123336.24551.2629.stgit@potku.adurom.net>
	<CAEFj987MkPQgyTU=K64mXuzCnm7T3SsUOSXiHkAovTVz0_kqwg@mail.gmail.com>
	<87ppnst7jl.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 16 Jan 2014 21:39:51 +0800
Message-ID: <CAEFj986GB5ehTMAWz-9qWOaqT=ck1T61AAgg-qxXLw-MS=q8cQ@mail.gmail.com> (sfid-20140116_143958_192101_BD3A8153)
Subject: Re: [PATCH] ath10k: enable firmware STA quick kickout
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested and worked.

Thanks

----
Chun-Yeow

On Thu, Jan 16, 2014 at 8:50 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:
>
>> Just would like to know whether the STA is deleted by FW when the FW
>> is sending the WMI_PEER_STA_KICKOUT_EVENTID to the host?
>
> AFAICS the firmware just sends the event and assumes that the host
> deletes the peer. Luckily in thise case it doesn't seem to do any peer
> management on it's own.
>
> --
> Kalle Valo
