Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64278 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab3GOQPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 12:15:51 -0400
Received: by mail-qa0-f49.google.com with SMTP id hu16so1706668qab.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jul 2013 09:15:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373747861.5549.0.camel@jlt4.sipsolutions.net>
References: <1373575017-25645-1-git-send-email-johannes@sipsolutions.net>
	<CAKf6xpu7iUSKWsFwsUnV2Nv2XjWepzaXv6s=3WvcgB6dY20oGQ@mail.gmail.com>
	<1373747861.5549.0.camel@jlt4.sipsolutions.net>
Date: Mon, 15 Jul 2013 12:15:50 -0400
Message-ID: <CAKf6xpsuw+sSq2LJzL2rQ44r7bzHAk4vYZ7+_K9=UAeBfEqBcQ@mail.gmail.com> (sfid-20130715_181554_844071_EA661B0B)
Subject: Re: [PATCH] mac80211: fix duplicate retransmission detection
From: Jason Andryuk <jandryuk@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 13, 2013 at 4:37 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2013-07-13 at 12:28 -0400, Jason Andryuk wrote:
>
>> > +       if (rx->skb->len >= 24 && rx->sta &&
>>
>> Shouldn't this check rx->skb first?
>> if (rx->sta && rx->sta->len >= 24 &&
>
> Hmm? did you mean rx->skb? But what makes you think it can be NULL???

Whoops, I totally misread sta v skb.  Sorry for the noise.

Jason
