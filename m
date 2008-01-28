Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:55649 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761838AbYA1Qg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 11:36:26 -0500
Message-ID: <479E047A.4080603@lwfinger.net> (sfid-20080128_163656_230637_B8B63038)
Date: Mon, 28 Jan 2008 09:36:10 -0700
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Lars Ericsson <Lars_Ericsson@telia.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT] [PATCH] rc80211-pid: fix rate adjusting
References: <20080127204606.63fbbaf7@morte>
In-Reply-To: <20080127204606.63fbbaf7@morte>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio wrote:
> Merge rate_control_pid_shift_adjust() to rate_control_pid_adjust_rate()
> in order to make the learning algorithm aware of constraints on rates. Also
> add some comments and rename variables.
> 
> This fixes a bug which prevented 802.11b/g non-AP STAs from working with
> 802.11b only AP STAs.
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> ---
> John, this should supersede the previously posted patches 1/2 and 2/2. This
> needs further testing anyway.
> 
> Larry, Lars, please test this. It works for me, both with 802.11b only and
> 802.11b/g settings on my AP.

Now that ieee80211_sta_work() no longer crashes on my machine, I have been able to test this patch. 
So far, it seems to work.

Larry

