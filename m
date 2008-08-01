Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.229]:2013 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYHAQnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 12:43:00 -0400
Received: by qb-out-0506.google.com with SMTP id a16so1115495qbd.17
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 09:42:59 -0700 (PDT)
Message-ID: <4893399E.8080503@tuffmail.co.uk> (sfid-20080801_184303_698404_31314DA7)
Date: Fri, 01 Aug 2008 17:28:14 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Jiri Slaby <jirislaby@gmail.com>, tomasw@gmail.com,
	Dave Young <hidave.darkstar@gmail.com>, stable@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linville@tuxdriver.com, Pekka Enberg <penberg@cs.helsinki.fi>,
	ath5k-devel@venema.h4ckr.net, johannes@sipsolutions.net,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ath5k-devel] [PATCH] ath5k : ath5k_config_interface deadlock
 fix
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>	<4892C359.9000304@cs.helsinki.fi>	<20080801011415.ff4821a3.akpm@linux-foundation.org>	<b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com>	<4893257C.1020907@gmail.com> <b6c5339f0808010823o434298ecn7b274c46fe857aba@mail.gmail.com>
In-Reply-To: <b6c5339f0808010823o434298ecn7b274c46fe857aba@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Fri, Aug 1, 2008 at 11:02 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>   
>>> Not to worry, the commit that introduced it was
>>> 9d139c810a2aa17365cc548d0cd2a189d8433c65, which as far as I can tell
>>> came in after 2.6.26.
>>>       
>> git-describe 9d139c810a2aa17365cc548d0cd2a189d8433c65
>> v2.6.26-rc8-1219-g9d139c8
>>     
>
> I'm not that expert in git, what does that mean?  Some other commits
> for 2.6.27 also show a 2.6.26-rc from git-describe (e.g. my
> 3a078876caee).
>
> For my own investigation, I did a 'git-checkout v2.6.26' and looked at
> the code to see the patch had not been applied yet.  Is there an
> easier way to definitively say commit X is/is not in tagged release Y?
>
>   

Aha!  I think we want git-describe --contains.

$ git-describe --contains 2b142900784c6e38c8d39fa57d5f95ef08e735d8
v2.6.27-rc1~55^2~1

Alan

