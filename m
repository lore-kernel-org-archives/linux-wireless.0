Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751133AbdHCJME (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:12:04 -0400
Date: Thu, 3 Aug 2017 11:10:49 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: mike@hellotwist.com
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: Fix MMIC countermeasures.
Message-ID: <20170803091048.GA2769@redhat.com> (sfid-20170803_111207_583109_D1E225EA)
References: <CAKXXJEw72EYHJpdwoWhudmOmFF=w+u_JG3vrp=-TCfR3zhANZw@mail.gmail.com>
 <20170802070117.GA2790@redhat.com>
 <1501676470.11126.2.camel@sipsolutions.net>
 <87h8xqrso6.fsf@kamboji.qca.qualcomm.com>
 <CAKXXJEwT0EK=dmswxP90WNJQcSM1sUAE3E46AzZ8Pd9a2XXtxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKXXJEwT0EK=dmswxP90WNJQcSM1sUAE3E46AzZ8Pd9a2XXtxg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 02, 2017 at 10:36:52AM -0400, Michael Skeffington wrote:
> I traced through this code during MMIC failure and
> ieee80211_rx_h_decrypt() drops the frame before getting to
> ieee80211_rx_h_michael_mic_verify().  Johannes suggested this change
> to me in response to a previous thread and I am offering this patch
> after having conducted the proper testing on it.

Ok, please repost the patch without mangling it i.e. using
git-send-email.

Thanks
Stanislaw
