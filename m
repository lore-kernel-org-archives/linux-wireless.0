Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55829 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbbLKIkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 03:40:10 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH V2 11/13] brcmfmac: Change error print in debug print
References: <1449751392-32569-1-git-send-email-arend@broadcom.com>
	<1449751392-32569-12-git-send-email-arend@broadcom.com>
Date: Fri, 11 Dec 2015 10:40:03 +0200
In-Reply-To: <1449751392-32569-12-git-send-email-arend@broadcom.com> (Arend
	van Spriel's message of "Thu, 10 Dec 2015 13:43:10 +0100")
Message-ID: <87mvth5qfw.fsf@kamboji.qca.qualcomm.com> (sfid-20151211_094015_183570_864509C8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> From: Hante Meuleman <meuleman@broadcom.com>
>
> The pcie suspend and resume routines contain some error prints,
> which should have been debug prints.
>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Change-Id: Ibafe5d38301ee8f5e86889259ddeaea4dcae4cee
> Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/5581
> Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

I'll fix this one also.

-- 
Kalle Valo
