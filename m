Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46371 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab2FTGJg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 02:09:36 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Victor Goldenshtein <victorg@ti.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH 7/7] mac80211: add DFS support to monitor interface
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
	<1340030798-28992-8-git-send-email-victorg@ti.com>
	<4FE01FDD.4080004@adurom.com>
	<1340089024.1631.143.camel@cumari.coelho.fi>
Date: Wed, 20 Jun 2012 09:09:19 +0300
In-Reply-To: <1340089024.1631.143.camel@cumari.coelho.fi> (Luciano Coelho's
	message of "Tue, 19 Jun 2012 09:57:04 +0300")
Message-ID: <87mx3y4ir4.fsf@purkki.adurom.net> (sfid-20120620_081002_857924_00124C24)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <coelho@ti.com> writes:

> On Tue, 2012-06-19 at 09:44 +0300, Kalle Valo wrote:
>> On 06/18/2012 05:46 PM, Victor Goldenshtein wrote:
>> > Stop dropping packets if we are on 'radar channel'
>> > and the DFS is enabled/supported.
>> > 
>> > Signed-off-by: Victor Goldenshtein <victorg@ti.com>
>> 
>> Why? I'm not very familiar with DFS so this change is not clear to me.
>
> That's not a good excuse. :P

Heh, I didn't first get your comment but when I reread the patch. I
thought this patch was about dropping _received_ frames in a monitor
interface but it was actually about dropping _injected_ frames. Makes
better sense now :)

-- 
Kalle Valo
