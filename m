Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:33043 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901AbYEaTCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2008 15:02:38 -0400
Received: by wa-out-1112.google.com with SMTP id j37so182063waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2008 12:02:38 -0700 (PDT)
Message-ID: <1ba2fa240805311202t3a88800m131d433cbe9ce9e2@mail.gmail.com> (sfid-20080531_210257_704531_7C8A9745)
Date: Sat, 31 May 2008 22:02:38 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] iwl4965: remove useless network and duplicate checking
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <20080530202212.GA21212@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211446997.3698.47.camel@johannes.berg>
	 <1ba2fa240805220341g69f3acb0qf03594f541232337@mail.gmail.com>
	 <1212175035.7238.8.camel@johannes.berg>
	 <20080530202212.GA21212@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 30, 2008 at 11:22 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, May 30, 2008 at 09:17:15PM +0200, Johannes Berg wrote:
>>
>> > > The iwlwifi drivers go to great lengths to avoid passing packets to
>> > > mac80211 they think shouldn't go there, while mac80211 can (of course!)
>> > > handle them very well.
>> > >
>> > > Especially in the case of duplicate packets this is interesting
>> > > because it's such a performance hog (especially for IBSS networks)
>> > > while mac80211 does that work on the side without much effort.
>> > >
>> > > This patch removes all that and leaves only what is absolutely
>> > > necessary for the hardware.
>>
>>
>> > Looks good to me. let me just repost it rebased over our latest code.
>>
>> ping? This one no longer applies.
>
> Was going to ask about that one myself...

I know that's I wanted to delay it. I preferred to rebase one patch
then many other. I will release it in next round, still have some code
movement. It also get proper testing.
Tomas

> --
> John W. Linville
> linville@tuxdriver.com
>
