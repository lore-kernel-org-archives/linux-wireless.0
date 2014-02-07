Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:42662 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbaBGMxg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 07:53:36 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Calvin Owens <jcalvinowens@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason codes
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
	<1391675824.12789.3.camel@jlt4.sipsolutions.net>
Date: Fri, 07 Feb 2014 14:53:32 +0200
In-Reply-To: <1391675824.12789.3.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Thu, 06 Feb 2014 09:37:04 +0100")
Message-ID: <87r47fkrsj.fsf@purkki.adurom.net> (sfid-20140207_135342_607730_FA75E975)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2014-02-05 at 19:44 -0600, Calvin Owens wrote:
>> Create a function to return a descriptive string for each reason code,
>> and print that instead of the numeric value in the kernel log. These
>> codes are easily found on popular search engines, but one is generally
>> not able to access the internet when dealing with wireless connectivity
>> issues.
>
> I believe both iw and wpa_supplicant already have the reason code
> printout, and if you're diagnosing connectivity issues then you're
> probably using those anyway (e.g. iw event -t), so I don't really see
> much point in adding this to the kernel?

FWIW I find this useful. When I have connection problems I rarely look
at wpasupplicant, mostly I'm so lazy that I just check from the kernel
log what's happening. Just my 0.02 EUR.

-- 
Kalle Valo
