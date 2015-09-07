Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54680 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbbIGIxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 04:53:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH v2 0/1] rtl8xxxu (mac80211) driver for rtl8188[cr]u/rtl8192cu/rtl8723au
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
	<87y4gjfw10.fsf@kamboji.qca.qualcomm.com>
	<wrfjfv2rf1e1.fsf@redhat.com> <wrfj37yqg8l5.fsf@redhat.com>
Date: Mon, 07 Sep 2015 11:53:29 +0300
In-Reply-To: <wrfj37yqg8l5.fsf@redhat.com> (Jes Sorensen's message of "Mon, 07
	Sep 2015 00:24:38 -0400")
Message-ID: <87h9n6fw52.fsf@kamboji.qca.qualcomm.com> (sfid-20150907_105339_759075_81F36220)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

>>> Also how do we make sure that distros don't enable
>>> CONFIG_RTL8XXXU_UNTESTED? They are notarious of enabling kconfig options
>>> without thinking.
>>
>> Some distros enable staging whether you ask them or not. I think
>> CONFIG_RTL8XXXYU_UNTESTED is pretty safe and will most likely just work
>> for the devices on that list, but the driver will spit out a warning
>> asking the person to report test results to me.
>
> Just one more note - we could put UNTESTED under EXPERIMENTAL

I think that's a good idea. Does anyone know if the distros use features
which depend on EXPERIMENTAL? I hope not.

-- 
Kalle Valo
