Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36659 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934177AbbJIIoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 04:44:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 00/10] wil6210 patches
References: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Fri, 09 Oct 2015 11:44:15 +0300
In-Reply-To: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Sun, 4 Oct 2015 10:23:17 +0300")
Message-ID: <878u7csa74.fsf@kamboji.qca.qualcomm.com> (sfid-20151009_104433_004679_E2A00018)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> New features:
> - BlockAckReq support
> - firmware crashdump using devcoredump
> - capture all frames with sniffer
>
> The rest of patches are fixes
>
> Hamad Kadmany (1):
>   wil6210: Do no schedule firmware recovery during reset flow
>
> Vladimir Kondratiev (8):
>   wil6210: fix warning in system power management code
>   wil6210: Add proper handling for invalid frames on Rx
>   wil6210: log firmware crash information
>   wil6210: treat broadcast bssid as "disconnect all"
>   wil6210: support BAR (BlockAck Req)
>   wil6210: capture all frames in sniffer mode
>   wil6210: ratelimit Tx error message
>   wil6210: dump firmware memory when firmware crashes
>
> Vladimir Shulman (1):
>   wil6210: pmc logger bug fix

Thanks, all 10 applied.

-- 
Kalle Valo
