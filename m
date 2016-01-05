Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36598 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbcAEK2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:28:25 -0500
Message-ID: <1451989702.12357.19.camel@sipsolutions.net> (sfid-20160105_112828_534733_F6508668)
Subject: Re: [PATCH] mac80211: add use_minrate param to
 ieee80211_tx_prepare_skb()
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Jan 2016 11:28:22 +0100
In-Reply-To: <CALhHN=o0Ydjw09h2zoqv0Zv6FwUe6fAogpGjgq5WYRDdL5rTEw@mail.gmail.com> (sfid-20160105_111820_192379_E5D9E4F0)
References: <1451984419-5727-1-git-send-email-janusz.dziedzic@tieto.com>
	 <20160105094504.GA3015@w1.fi>
	 <CALhHN=qfmdQuTeHEAvE0BgS2XvZJrBVUhU3BYgXMCY-pe5Ur0g@mail.gmail.com>
	 <20160105100659.GA3864@w1.fi>
	 <CALhHN=q1kFn7tTQNhj=WH+7RUz+KT+fn9ovBaYJ_wzE5TtXu8Q@mail.gmail.com>
	 <CALhHN=o0Ydjw09h2zoqv0Zv6FwUe6fAogpGjgq5WYRDdL5rTEw@mail.gmail.com>
	 (sfid-20160105_111820_192379_E5D9E4F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-05 at 11:18 +0100, Janusz Dziedzic wrote:
> 
> BTW, should we export more params except minrate. I see also
> IEEE80211_TX_CTL_NO_CCK_RATE is used??

That would be required for P2P.


johannes
