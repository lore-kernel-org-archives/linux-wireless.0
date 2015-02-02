Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:60084 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbBBRZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 12:25:29 -0500
Message-ID: <54CFB2EC.5070307@codeaurora.org> (sfid-20150202_182532_082511_59961289)
Date: Mon, 02 Feb 2015 09:25:00 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>,
	Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com> <20150127213349.GA24933@localhost> <54C824DC.5080804@qca.qualcomm.com> <20150128043005.GB24933@localhost> <54C875FD.3070101@qca.qualcomm.com> <1422430643.1973.1.camel@sipsolutions.net> <54CC0B71.9050301@codeaurora.org> <21708.11481.380046.994311@gargle.gargle.HOWL> <54CC3640.2090209@codeaurora.org> <21708.14493.458370.65799@gargle.gargle.HOWL>
In-Reply-To: <21708.14493.458370.65799@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 01/30/2015 06:06 PM, Sujith Manoharan wrote:
> Peter Oh wrote:
>> Please refer the email thread that I mentioned about other
> architectures.
>> (dsb is for ARM and other platforms have the equivalent instruction such
>> as sfence, sync, mf, and dcs).
> Ok.
>
>> Also the patch is updated with 2nd patch set replacing wmb to mb.
> Would be good to test this on a MIPS platform...
Agree. I'll do the investigation and test.
> Sujith
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
Thanks,
Peter
