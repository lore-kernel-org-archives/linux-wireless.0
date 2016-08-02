Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36385 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936036AbcHBRxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 13:53:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Baole Ni <baolex.ni@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0768/1285] Replace numeric parameter like 0444 with macro
References: <20160802114428.860-1-baolex.ni@intel.com>
Date: Tue, 02 Aug 2016 20:52:15 +0300
In-Reply-To: <20160802114428.860-1-baolex.ni@intel.com> (Baole Ni's message of
	"Tue, 2 Aug 2016 19:44:28 +0800")
Message-ID: <87k2fz5a9c.fsf@kamboji.qca.qualcomm.com> (sfid-20160802_195405_674586_6AD94B1E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Trimming CC)

Baole Ni <baolex.ni@intel.com> writes:

> I find that the developers often just specified the numeric value
> when calling a macro which is defined with a parameter for access permission.
> As we know, these numeric value for access permission have had the corresponding macro,
> and that using macro can improve the robustness and readability of the code,
> thus, I suggest replacing the numeric parameter with the macro.
>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Baole Ni <baolex.ni@intel.com>
> ---
>  drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Over 1000 patches? It's totally inapproriate to spam people's inboxes
(including mine) like this. PLEASE first study how kernel development
works and then start with something small, not like this.

I'm dropping all patches from this patchset.

-- 
Kalle Valo
