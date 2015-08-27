Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50110 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbbH0HNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 03:13:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/12] brcmfmac: multiple interface rework and cleanup
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
Date: Thu, 27 Aug 2015 10:13:05 +0300
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Wed, 26 Aug 2015 22:14:52 +0200")
Message-ID: <87egipxkzi.fsf@kamboji.qca.qualcomm.com> (sfid-20150827_091315_741999_7D163B62)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> This patch series contains the following:
> * rework code dealing with multiple interfaces.
> * allow logging firmware console using debug level.
> * fix crash in error path when probe fails.
> * fix memory leak in free net devices.
> * minor code cleanup.
>
> The patch series is intended for v4.3 and applies to the master
> branch of the wireless-drivers-next repository.

Most likely the merge window starts on Sunday so I'm not able to send
these to 4.3 anymore. But if the merge window gets delayed again when
I'll send this.

-- 
Kalle Valo
