Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60365 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1ISGs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 02:48:27 -0400
Message-ID: <4E76E5B7.4050202@qca.qualcomm.com> (sfid-20110919_084831_493143_1122A646)
Date: Mon, 19 Sep 2011 09:48:23 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath6kl: Remove auth type fall back in auto	authentication
 mode
References: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com> <4E7201BE.704@qca.qualcomm.com> <20110915143632.GA6965@vasanth-laptop>
In-Reply-To: <20110915143632.GA6965@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2011 05:36 PM, Vasanthakumar Thiagarajan wrote:
> On Thu, Sep 15, 2011 at 04:46:38PM +0300, Kalle Valo wrote:
>> On 09/10/2011 12:56 PM, Vasanthakumar Thiagarajan wrote:
>>> Target already tries with different authentication mechanism
>>> when authentication type is configured to NL80211_AUTHTYPE_AUTOMATIC.
>>> Remove this piece of code from driver. Having this code in driver
>>> even affects auto + WEP authentication in some cases.
>>
>> Thanks, patches 1-3 applied. Patch 4 dropped per your request. Please
>> resend it once it's ready.
> 
> Sorry for the delay but the patch 3 also seems to be problematic
> sometime. Can you please drop 3 as well?. The disconnect event 
> still not clear to me.

You got lucky, I forgot to push the patches :) So I was able to easily
drop patch 3.

Kalle
