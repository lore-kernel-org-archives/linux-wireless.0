Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:47568 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbYFYKf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 06:35:28 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1059480waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 03:35:27 -0700 (PDT)
Message-ID: <1ba2fa240806250335g7251fe9ax5a470990357f0b71@mail.gmail.com> (sfid-20080625_123531_248735_2CBCA9B0)
Date: Wed, 25 Jun 2008 13:35:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Broken fragmentation
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <1214389930.21847.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1213889200.8967.26.camel@johannes.berg>
	 <1ba2fa240806191113nd6a221eiac9648edd3404a80@mail.gmail.com>
	 <1213899419.8967.59.camel@johannes.berg>
	 <1ba2fa240806191409k7200ad53y654a7f8a117c8f14@mail.gmail.com>
	 <1213910734.8967.117.camel@johannes.berg>
	 <1ba2fa240806250250k2ae66eddre00172f6bc871fcb@mail.gmail.com>
	 <1214388133.21847.8.camel@johannes.berg>
	 <1ba2fa240806250330s15168d22i50e61498fbba6af7@mail.gmail.com>
	 <1214389930.21847.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 25, 2008 at 1:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-06-25 at 13:30 +0300, Tomas Winkler wrote:
>
>> >> So the bug is still in mac80211. Fragments are scheduled to different
>> >> TIDs and hence to different queues.
>> >> Investigating further. If you have something in mind let me know
>> >
>> > Hmm, yes, I do indeed, try
>> >
>> > skb_copy_queue_mapping(frag, first);
>> >
>> > where you previously added the cb copy.
>
>> Yeah just found that too 2 min ago :)
>
> :)
>
> Before it happens again, can you think of anything else we need to copy?

Not sure, now it works.
Shell I send a patch or blend it into the original one.
Thanks

> johannes
>
