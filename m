Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:15191 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYHAPYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 11:24:00 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1508721wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 08:23:59 -0700 (PDT)
Message-ID: <b6c5339f0808010823o434298ecn7b274c46fe857aba@mail.gmail.com> (sfid-20080801_172405_262483_161873C0)
Date: Fri, 1 Aug 2008 11:23:59 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] ath5k : ath5k_config_interface deadlock fix
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Pekka Enberg" <penberg@cs.helsinki.fi>,
	"Dave Young" <hidave.darkstar@gmail.com>,
	johannes@sipsolutions.net, tomasw@gmail.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	stable@kernel.org
In-Reply-To: <4893257C.1020907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>
	 <4892C359.9000304@cs.helsinki.fi>
	 <20080801011415.ff4821a3.akpm@linux-foundation.org>
	 <b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com>
	 <4893257C.1020907@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 1, 2008 at 11:02 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>> Not to worry, the commit that introduced it was
>> 9d139c810a2aa17365cc548d0cd2a189d8433c65, which as far as I can tell
>> came in after 2.6.26.
>
> git-describe 9d139c810a2aa17365cc548d0cd2a189d8433c65
> v2.6.26-rc8-1219-g9d139c8

I'm not that expert in git, what does that mean?  Some other commits
for 2.6.27 also show a 2.6.26-rc from git-describe (e.g. my
3a078876caee).

For my own investigation, I did a 'git-checkout v2.6.26' and looked at
the code to see the patch had not been applied yet.  Is there an
easier way to definitively say commit X is/is not in tagged release Y?

-- 
Bob Copeland %% www.bobcopeland.com
