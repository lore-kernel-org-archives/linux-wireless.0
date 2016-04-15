Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52627 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbcDOOZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 10:25:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Pontus Fuchs <pontus.fuchs@gmail.com>,
	wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] wcn36xx: Clean up wcn36xx_smd_send_beacon
References: <1459721806-11817-1-git-send-email-bjorn.andersson@linaro.org>
	<20160414005935.GO391@tuxbot>
Date: Fri, 15 Apr 2016 17:25:12 +0300
In-Reply-To: <20160414005935.GO391@tuxbot> (Bjorn Andersson's message of "Wed,
	13 Apr 2016 17:59:35 -0700")
Message-ID: <87shynoson.fsf@kamboji.qca.qualcomm.com> (sfid-20160415_162552_207926_1838CC48)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Andersson <bjorn.andersson@linaro.org> writes:

> On Sun 03 Apr 15:16 PDT 2016, Bjorn Andersson wrote:
>
>> From: Pontus Fuchs <pontus.fuchs@gmail.com>
>> 
>> Needed for coming improvements. No functional changes.
>> 
>
> Kalle, Eugene,
>
> Have you picked up these patches yet?
>
> As I was debugging a firmware crash when trying to start hostap on the
> DragonBoard410c I found an issue with this patch, would like to know if
> I should send an incremental patch or resend this one.

I haven't applied these yet, so please resend the whole series as v3.

-- 
Kalle Valo
