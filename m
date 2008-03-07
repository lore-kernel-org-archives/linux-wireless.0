Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:54818 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765513AbYCGUhu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 15:37:50 -0500
Message-ID: <47D1A7AC.6010307@work.ksp.sk> (sfid-20080307_203755_474038_5BDDA107)
Date: Fri, 07 Mar 2008 21:38:04 +0100
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>, mcgrof@gmail.com
CC: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: 2.6.24, mac80211 and b/g switching
References: <47D160E4.3040503@work.ksp.sk> <1204909966.6387.31.camel@johannes.berg> <47D17EDF.4010100@work.ksp.sk> <200803071916.28776.mb@bu3sch.de> <20080307193429.GA5561@tuxdriver.com>
In-Reply-To: <20080307193429.GA5561@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
>>> Do you think that taking mac80211 from wireless-2.6 (or -testing or
>>> whatever) would cause way too many conflicts when merged back to 2.6.24?
>>>   Or am I on my own to fix this somehow in 2.6.24?
>> OpenWRT ported a rather recent mac80211 back to 2.6.23. So it shouldn't be too hard.
> 
> Current 2.6.24-based Fedora kernels take current mac80211 bits fairly easily.

Ok, thanks for this info, I might change my plans then. I'll try this
way first, or (if that fails) the compat-wireless-2.6 path suggested by
Luis.

Thanks,
 Vlado

> 
> John


