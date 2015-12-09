Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59945 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbLINGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 08:06:15 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 01/13] brcmfmac: Simplify scan timing configuration.
References: <1449656572-16158-1-git-send-email-arend@broadcom.com>
	<1449656572-16158-2-git-send-email-arend@broadcom.com>
Date: Wed, 09 Dec 2015 15:06:07 +0200
In-Reply-To: <1449656572-16158-2-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Wed, 9 Dec 2015 11:22:40 +0100")
Message-ID: <87zixj93gg.fsf@kamboji.qca.qualcomm.com> (sfid-20151209_140618_872525_291983D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> From: Hante Meuleman <meuleman@broadcom.com>
>

Please, no empty commit logs. For a patch like this it takes like 30
seconds to write a short log describing why and how you are simplifying
the code. Next year I'm thinking of start rejecting patches without a
commit log.

This is a minor nitpick but it's not that common to the commit title
with a period.

> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Change-Id: Ie179527eb29f2ed8b7869dac24591e2513775393
> Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/5445
> Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Forgot to clean the tags? :)

-- 
Kalle Valo
