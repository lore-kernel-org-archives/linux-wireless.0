Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51191 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbbKQOHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 09:07:18 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: linux-wireless rebased (probably for the last time) on 4.4-rc1
References: <20151116195551.GD8895@tuxdriver.com>
Date: Tue, 17 Nov 2015 16:07:11 +0200
In-Reply-To: <20151116195551.GD8895@tuxdriver.com> (John W. Linville's message
	of "Mon, 16 Nov 2015 14:55:53 -0500")
Message-ID: <87oaesyb1s.fsf@kamboji.qca.qualcomm.com> (sfid-20151117_150733_412548_00D4A062)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> The wireless-testing tree has been rebased on top of 4.4-rc1.  The
> current head of the tree is eced3b090878ddba643bbed599e6edea4ad90f49.
> Please update any downstream trees accordingly!
>
> It has been almost a year since I turned-over wireless maintenance
> duties to Johannes and Kalle. At that time I agreed to continue
> maintaining the wireless-testing tree for the duration of 2015 to help
> those that were still relying on it. The end of 2015 is coming soon,
> and with it I intend to stop maintaining wireless-testing.
>
> If you are still relying on wireless-testing, then I implore you to
> find another option to satisfy your needs. If someone would like to
> continue maintaining wireless-testing yourself, then please contact
> me and I will attempt to assist you in such a transition.
>
> Thanks for all the fish!

Thank you John. I have been using wireless-testing in my main laptop for
god knows how many years and I hate to see it go. I consider it as the
safest way to test the latest wireless code as it's just the latest -rc
release from Linux plus mac80211 and wireless-drivers trees. linux-next
is just too experimental for me, I don't want that anywhere near my
laptop :) It would be interesting to know what others think about
wireless-testing and how much users that tree really has?

I hope we can find some solution and wireless-testing continues to
exist. Otherwise testing latest wireless code will become more
difficult.

-- 
Kalle Valo
