Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16729 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3CRLqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 07:46:35 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath6kl-devel@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] ath6kl: tracing support
References: <20130309130223.13371.75809.stgit@localhost6.localdomain6>
Date: Mon, 18 Mar 2013 13:46:29 +0200
In-Reply-To: <20130309130223.13371.75809.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Sat, 9 Mar 2013 15:04:57 +0200")
Message-ID: <87li9l7wx6.fsf@kamboji.qca.qualcomm.com> (sfid-20130318_124640_396975_BCE9A14E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Second version of the tracing support to ath6kl. Changes based on
> Johannes' comments.
>
> v2:
>
> o simplify sdio trace calls so that their overhead is smaller when tracing is disabled
>
> o add ath6kl_sdio_scat for scatter gather
>
> o uninline ath6kl_info/warn/err() functions, fixes a compilation warning
>
> ---
>
> Kalle Valo (7):
>       ath6kl: add tracing support and tracing points for wmi packets
>       ath6kl: add tracing points for sdio transfers
>       ath6kl: add tracing point for hif irqs
>       ath6kl: adding tracing points for htc_mbox
>       ath6kl: convert ath6kl_info/err/warn macros to real functions
>       ath6kl: add tracing support to log functions
>       ath6kl: add tracing support to debug message macros

All seven applied. Fixed a small whitespace problem in patch 5 at the
same time.

-- 
Kalle Valo
