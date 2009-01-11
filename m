Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37334 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZAKGV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 01:21:27 -0500
Received: by bwz14 with SMTP id 14so30747268bwz.13
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 22:21:25 -0800 (PST)
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
Subject: Re: drivers returning wrong results from their _tx op
References: <1231193264.3697.41.camel@johannes>
	<b6c5339f0901051424q12d8fc14o8f20b62cfacc4e6e@mail.gmail.com>
	<1231246859.3503.0.camel@johannes>
	<20090109022347.GA5077@hash.localnet> <87hc4828xn.fsf@litku.valot.fi>
	<20090109153716.M19288@bobcopeland.com>
	<87hc48tpwa.fsf@litku.valot.fi> <20090109182142.M2510@bobcopeland.com>
	<87zli0s4di.fsf@litku.valot.fi> <20090111031202.GA11778@hash.localnet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 11 Jan 2009 08:21:20 +0200
In-Reply-To: <20090111031202.GA11778@hash.localnet> (Bob Copeland's message of "Sat\, 10 Jan 2009 22\:12\:02 -0500")
Message-ID: <87bpues6qn.fsf@litku.valot.fi> (sfid-20090111_072132_185800_1DA8F3FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> On Fri, Jan 09, 2009 at 08:47:53PM +0200, Kalle Valo wrote:
>> Yes, that's why it's already better to deny this kind of usage in
>> documentation already now.
>
> Good point.. ok, here's an update.

Looks good to me.

> From: Bob Copeland <me@bobcopeland.com>
> Date: Thu, 8 Jan 2009 21:00:34 -0500
> Subject: [PATCH] mac80211: document return codes from ops callbacks
>
> For any callbacks in ieee80211_ops, specify what values the return
> codes represent.  While at it, fix a couple of capitalization and
> punctuation differences.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Reviewed-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
