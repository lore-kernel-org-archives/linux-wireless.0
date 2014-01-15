Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaAONVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:21:34 -0500
Message-ID: <1389792091.4338.5.camel@jlt4.sipsolutions.net> (sfid-20140115_142137_798892_2AEE92A1)
Subject: Re: [RFC 0/9] mac80211: multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Jan 2014 14:21:31 +0100
In-Reply-To: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com> (sfid-20140115_130924_614281_8201EA84)
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140115_130924_614281_8201EA84)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 13:04 +0100, Michal Kazior wrote:
> Hi,
> 
> This patchet bases of my recently posted cfg80211
> multi-interface CSA patchset.
> 
> Probably some patches in this patchset can be
> cherry-picked regardless if the multi-interface
> CSA itself is accepted or not.
> 
> I'm planning on posting properly split patchsets
> after getting some feedback on the mac80211 part.

I guess overall this looks fine, as Luca said it needs to be rebased.

It'd be great to have some tests in the hostapd test suite (once support
is there) so I can run them as well over hwsim.

johannes

