Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:14019 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYKPSUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 13:20:25 -0500
Received: by yx-out-2324.google.com with SMTP id 8so905904yxm.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Nov 2008 10:20:24 -0800 (PST)
Message-ID: <43e72e890811161020n2647416doda69839f2a6ba93@mail.gmail.com> (sfid-20081116_192029_417336_AB0BA52E)
Date: Sun, 16 Nov 2008 10:20:24 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Dan McGee" <dpmcgee@gmail.com>,
	"Bob Copeland" <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <1226858723.3599.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	 <20081116055312.GA14126@hash.localnet>
	 <43e72e890811152205k13318ab7yad8695d9f6dd409c@mail.gmail.com>
	 <43e72e890811152206s3683ecabm658fac255112a262@mail.gmail.com>
	 <43e72e890811152215h5cf389a3ufe4dc10b021b0c0f@mail.gmail.com>
	 <20081116162019.GA15851@hash.localnet>
	 <449c10960811160838h70fd1852g66d8a51c7551530b@mail.gmail.com>
	 <20081116165213.GC14126@hash.localnet>
	 <449c10960811161001h547a7ab0l937bba6bec9d46aa@mail.gmail.com>
	 <1226858723.3599.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 16, 2008 at 10:05 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-11-16 at 12:01 -0600, Dan McGee wrote:
>
>> I had not seen this cfg80211 stuff before when modprobing. I also see
>> that cfg80211 is now loaded as a module- was the fact that it was
>> built into the kernel before causing all these problems? That would be
>> my strong suspicion, in which case this entire thread is really a bum
>> bug report, except that compat-wireless should enforce that cfg80211
>> is a module just like it currently enforces that for mac80211, saving
>> someone else this headache.
>
> Let me guess, symbol versioning was off?

/me adds complaint on compat-wireless if cfg80211 is built in
