Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:36044 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab2FSGuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 02:50:46 -0400
Message-ID: <4FE01FDD.4080004@adurom.com> (sfid-20120619_085113_811469_C5544BDF)
Date: Tue, 19 Jun 2012 09:44:45 +0300
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: Victor Goldenshtein <victorg@ti.com>
CC: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH 7/7] mac80211: add DFS support to monitor interface
References: <1340030798-28992-1-git-send-email-victorg@ti.com> <1340030798-28992-8-git-send-email-victorg@ti.com>
In-Reply-To: <1340030798-28992-8-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2012 05:46 PM, Victor Goldenshtein wrote:
> Stop dropping packets if we are on 'radar channel'
> and the DFS is enabled/supported.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>

Why? I'm not very familiar with DFS so this change is not clear to me.
You could write more about the reasoning in the commit log.

Kalle
