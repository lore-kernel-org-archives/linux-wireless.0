Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62532 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbbDONDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 09:03:06 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>,
	<janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath10k: ibss crypto fixes
References: <1428672203-8604-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 15 Apr 2015 16:02:56 +0300
In-Reply-To: <1428672203-8604-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 10 Apr 2015 13:23:19 +0000")
Message-ID: <87bnip7ddr.fsf@kamboji.qca.qualcomm.com> (sfid-20150415_150312_598144_B0DA58C9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> I've mainly tested this on kvalo/pending branch.
> Currently master branch contains 0f611d28fc2e
> ("mac80211: count interfaces correctly for
> combination checks") which breaks IBSS in
> wpa_supplicant due to P2P Device and interface
> combinations. This has been pointed out in the
> following thread:
>
>  [1]: http://thread.gmane.org/gmane.linux.kernel.wireless.general/135570/focus=136643
>
> If someone's interested in running ath10k IBSS
> make sure to use kernel prior to 4.0, revert the
> mentioned mac80211 patch or apply wpa_supplicant
> workaround patch from [1].

Is this IBSS regression fixed now or what's the status?

-- 
Kalle Valo
