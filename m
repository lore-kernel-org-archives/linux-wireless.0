Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:42146 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbbAWTAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 14:00:45 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>, <gaoqs@marvell.com>
Subject: Re: [PATCH 00/10] mwifiex: DFS support for mwifiex AP
References: <1421252138-30157-1-git-send-email-patila@marvell.com>
Date: Fri, 23 Jan 2015 21:00:37 +0200
In-Reply-To: <1421252138-30157-1-git-send-email-patila@marvell.com> (Avinash
	Patil's message of "Wed, 14 Jan 2015 21:45:28 +0530")
Message-ID: <87d265l3u2.fsf@kamboji.qca.qualcomm.com> (sfid-20150123_200055_397391_A8D322D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avinash Patil <patila@marvell.com> writes:

> This patch series adds DFS support for mwifiex AP. Series include
> patches to handle cfg80211 start_radar_detection and channel_switch
> handlers. First 5 patches are actually refactoring effort. Patch6-10
> add these handlers and other DFS handling.
>
> Avinash Patil (10):
>   mwifiex: do not send regulatory update while starting AP
>   mwifiex: store AP configuration in private structure
>   mwifiex: update IEs after AP has started
>   mwifiex: refactor start_ap handler
>   mwifiex: separate function for parsing head and tail IEs
>   mwifiex: add cfg80211 start_radar_detection handler
>   mwifiex: support for channel report for radar detection
>   mwifiex: handle radar detect event from FW
>   mwifiex: channel switch support for mwifiex
>   mwifiex: 11h handling for AP interface

Patch 5 had conflicts, please rebase.

-- 
Kalle Valo
