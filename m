Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:37233 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753202Ab3JULqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 07:46:53 -0400
Message-ID: <5265142B.5050000@free-electrons.com> (sfid-20131021_134717_915709_43C104F5)
Date: Mon, 21 Oct 2013 13:46:51 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac80211: document IEEE80211_HW_SUPPORTS_HT_CCK_RATES
References: <1382251529-22540-1-git-send-email-michael.opdenacker@free-electrons.com> <1382350961.14310.42.camel@jlt4.sipsolutions.net>
In-Reply-To: <1382350961.14310.42.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 10/21/2013 12:22 PM, Johannes Berg wrote:
> On Sun, 2013-10-20 at 08:45 +0200, Michael Opdenacker wrote:
>> This patch documents the IEEE80211_HW_SUPPORTS_HT_CCK_RATES flag
>> in ieee80211_hw_flags.
>>
>> Without this, you get countless warnings in "make htmldocs".
> I already have an equivalent patch with correct documentation :)

Great! Then let's use your patch :)

Thanks,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

