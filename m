Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19132 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1IOOhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 10:37:08 -0400
Date: Thu, 15 Sep 2011 20:06:33 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath6kl: Remove auth type fall back in auto
	authentication mode
Message-ID: <20110915143632.GA6965@vasanth-laptop> (sfid-20110915_163712_264865_E24CEC10)
References: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com> <4E7201BE.704@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E7201BE.704@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 15, 2011 at 04:46:38PM +0300, Kalle Valo wrote:
> On 09/10/2011 12:56 PM, Vasanthakumar Thiagarajan wrote:
> > Target already tries with different authentication mechanism
> > when authentication type is configured to NL80211_AUTHTYPE_AUTOMATIC.
> > Remove this piece of code from driver. Having this code in driver
> > even affects auto + WEP authentication in some cases.
> 
> Thanks, patches 1-3 applied. Patch 4 dropped per your request. Please
> resend it once it's ready.

Sorry for the delay but the patch 3 also seems to be problematic
sometime. Can you please drop 3 as well?. The disconnect event 
still not clear to me.

Vasanth
