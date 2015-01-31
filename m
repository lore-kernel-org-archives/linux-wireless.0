Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:57249 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbbAaB43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 20:56:29 -0500
Message-ID: <54CC3640.2090209@codeaurora.org> (sfid-20150131_025904_251781_FB54F5C2)
Date: Fri, 30 Jan 2015 17:56:16 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	Peter Oh <poh@qca.qualcomm.com>
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com> <20150127213349.GA24933@localhost> <54C824DC.5080804@qca.qualcomm.com> <20150128043005.GB24933@localhost> <54C875FD.3070101@qca.qualcomm.com> <1422430643.1973.1.camel@sipsolutions.net> <54CC0B71.9050301@codeaurora.org> <21708.11481.380046.994311@gargle.gargle.HOWL>
In-Reply-To: <21708.11481.380046.994311@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 01/30/2015 05:16 PM, Sujith Manoharan wrote:
> Peter Oh wrote:
>> As I addressed wmb uses dsb (in arm arch) and here is the description of
>> arm architecture.
> What about other architectures ?
Please refer the email thread that I mentioned about other architectures.
(dsb is for ARM and other platforms have the equivalent instruction such 
as sfence, sync, mf, and dcs).
Also the patch is updated with 2nd patch set replacing wmb to mb.
> Sujith
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k

