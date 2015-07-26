Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51367 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbbGZL5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2015 07:57:37 -0400
Received: from potku.adurom.net (a88-115-185-251.elisa-laajakaista.fi [88.115.185.251])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: kvalo@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id 446641401E9
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2015 11:57:35 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: fix linking problem with of_default_bus_match_table
References: <1437633104-23373-1-git-send-email-kvalo@codeaurora.org>
Date: Sun, 26 Jul 2015 14:57:33 +0300
In-Reply-To: <1437633104-23373-1-git-send-email-kvalo@codeaurora.org> (Kalle
	Valo's message of "Thu, 23 Jul 2015 09:31:44 +0300")
Message-ID: <87h9orb07m.fsf@kamboji.qca.qualcomm.com> (sfid-20150726_135751_812541_1C696344)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Stephen reported a build problem caused by commit cae761b5a6bd ("bcma: populate
> bus DT subnodes as platform_device-s"):
>
> ERROR: "of_default_bus_match_table" [drivers/bcma/bcma.ko] undefined!
>
> Rafał Miłecki suggested as a quick fix to use IS_BUILTIN() to workaround the
> issue. The downside is that this won't work when BCMA is compiled as a module,
> but we can live with that for now just to unblock the breakage.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: cae761b5a6bd ("bcma: populate bus DT subnodes as platform_device-s")
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

I dropped this as Hauke sent a better patch.

-- 
Kalle Valo
