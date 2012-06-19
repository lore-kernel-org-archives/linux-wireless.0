Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:35507 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048Ab2FSG5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 02:57:11 -0400
Received: by lbon10 with SMTP id n10so6517194lbo.13
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 23:57:08 -0700 (PDT)
Message-ID: <1340089024.1631.143.camel@cumari.coelho.fi> (sfid-20120619_085719_159251_D4000C71)
Subject: Re: [PATCH 7/7] mac80211: add DFS support to monitor interface
From: Luciano Coelho <coelho@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Victor Goldenshtein <victorg@ti.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Tue, 19 Jun 2012 09:57:04 +0300
In-Reply-To: <4FE01FDD.4080004@adurom.com>
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
	 <1340030798-28992-8-git-send-email-victorg@ti.com>
	 <4FE01FDD.4080004@adurom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-19 at 09:44 +0300, Kalle Valo wrote:
> On 06/18/2012 05:46 PM, Victor Goldenshtein wrote:
> > Stop dropping packets if we are on 'radar channel'
> > and the DFS is enabled/supported.
> > 
> > Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> 
> Why? I'm not very familiar with DFS so this change is not clear to me.

That's not a good excuse. :P

> You could write more about the reasoning in the commit log.

But I totally agree that the "why" is missing here. ;)

--
Luca.

