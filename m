Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62853 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1KMKaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Nov 2011 05:30:17 -0500
Message-ID: <4EBF9C30.60801@qca.qualcomm.com> (sfid-20111113_113022_468394_8F7A2441)
Date: Sun, 13 Nov 2011 12:30:08 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix call trace while starting IBSS mode
References: <1320838343-5708-1-git-send-email-rmani@qca.qualcomm.com> <4EBF9B9F.2000307@qca.qualcomm.com>
In-Reply-To: <4EBF9B9F.2000307@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2011 12:27 PM, Kalle Valo wrote:
> On 11/09/2011 01:32 PM, Raja Mani wrote:
>> When the connect event is received from the target in IBSS mode,
>> cfg80211_ibss_joined() is called without informing BSS info to
>> cfg80211 layer which internally hits the below WARN_ON message.

[...]

> Thanks, applied.

Sorry, forgot to mention that I changed the patch title to:

    ath6kl: Fix cfg80211 warning while starting IBSS mode

Kalle
