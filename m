Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51481 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbcCGMwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:52:10 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V11 2/2] brcmfmac: add support for nl80211 BSS_SELECT feature
References: <1456947439-28968-1-git-send-email-arend@broadcom.com>
	<1456947439-28968-2-git-send-email-arend@broadcom.com>
Date: Mon, 07 Mar 2016 14:52:04 +0200
In-Reply-To: <1456947439-28968-2-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Wed, 2 Mar 2016 20:37:19 +0100")
Message-ID: <87a8matpqj.fsf@kamboji.qca.qualcomm.com> (sfid-20160307_135214_681727_B093E4F7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> Announce support for nl80211 feature BSS_SELECT and process
> BSS selection behaviour provided in .connect() callback.
>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Lei Zhang <leizh@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Depends on:

0a87cadbb54e nl80211: add feature for BSS selection support

Is in mac80211-next currently.

-- 
Kalle Valo
