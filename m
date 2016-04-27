Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50971 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbcD0M4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 08:56:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH v2 0/7] wil6210 patches
References: <1461589078-29854-1-git-send-email-qca_merez@qca.qualcomm.com>
Date: Wed, 27 Apr 2016 15:56:40 +0300
In-Reply-To: <1461589078-29854-1-git-send-email-qca_merez@qca.qualcomm.com>
	(Maya Erez's message of "Mon, 25 Apr 2016 15:57:51 +0300")
Message-ID: <871t5rw6pj.fsf@kamboji.qca.qualcomm.com> (sfid-20160427_145648_966234_8D912F34)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> Changes in V2:
> - reomoved __func__ addition from wil_dbg macros
> - Changed wil_dbg_ratelimited implementation to address code review comments
>
> Various of wil6210 fixes
>
> Lior David (1):
>   wil6210: support regular scan on P2P_DEVICE interface
>
> Maya Erez (6):
>   wil6210: add function name to wil log macros
>   wil6210: change RX_HTRSH interrupt print level to debug
>   wil6210: print debug message when transmitting while disconnected
>   wil6210: unmask RX_HTRSH interrupt only when connected
>   wil6210: prevent deep sleep of 60G device in critical paths

Applied these six patches, thanks.

>   wil6210: add support for device led configuration

This is still in pending branch due to my question.

-- 
Kalle Valo
