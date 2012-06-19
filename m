Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:54052 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586Ab2FSIma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 04:42:30 -0400
Received: by lbbgg6 with SMTP id gg6so7291213lbb.22
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 01:42:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE01FDD.4080004@adurom.com>
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
	<1340030798-28992-8-git-send-email-victorg@ti.com>
	<4FE01FDD.4080004@adurom.com>
Date: Tue, 19 Jun 2012 11:42:23 +0300
Message-ID: <CAK80WHbuJ7o8i9=tBfg1m7mavPbAw2on7mWTJ-XGCE1uQu1Knw@mail.gmail.com> (sfid-20120619_104235_683708_4DA9B238)
Subject: Re: [PATCH 7/7] mac80211: add DFS support to monitor interface
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 19, 2012 at 9:44 AM, Kalle Valo <kvalo@adurom.com> wrote:
> On 06/18/2012 05:46 PM, Victor Goldenshtein wrote:
>> Stop dropping packets if we are on 'radar channel'
>> and the DFS is enabled/supported.
>>
>> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
>
> Why? I'm not very familiar with DFS so this change is not clear to me.
> You could write more about the reasoning in the commit log.

I will update the commit log message.

-- 
Thanks,
Victor.
