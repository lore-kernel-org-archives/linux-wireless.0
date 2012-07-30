Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48270 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2G3XkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 19:40:06 -0400
Received: by obbuo13 with SMTP id uo13so9711375obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2012 16:40:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207272316.32411.chunkeey@googlemail.com>
References: <1343332743-11845-1-git-send-email-jlopex@cozybit.com>
	<201207271630.06025.chunkeey@googlemail.com>
	<CAPjQAd_Ko_WFEoG6uXk7hYYAggL6jbGiuKWdp=f3Aa+JdXNNJg@mail.gmail.com>
	<201207272316.32411.chunkeey@googlemail.com>
Date: Mon, 30 Jul 2012 16:40:05 -0700
Message-ID: <CAMr9ZPnJNwO-okEUXxjicu4iMViPYbhF6gMu96np0GNk5xRA5Q@mail.gmail.com> (sfid-20120731_014013_824300_D727DEE8)
Subject: Re: [PATCH] carl9170: Add support for NL80211_IFTYPE_MESH_POINT interfaces
From: Javier Lopez <jlopex@cozybit.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

I just wanted to give you an update about the mesh support on
carl9170. Today we've been testing the unique carl9170 card we have, a
D-link DWA-160.

We tested on a mesh network with 5 nodes (1 carl9170 + 4 ath9k_htc
cards) and we haven't seen any problem on this setup. All mesh
functionalities seem to work correctly.

We are still waiting to receive more carl9170 cards, once we have them
we'll run new tests on them.

Cheers,

Jlo



On Fri, Jul 27, 2012 at 2:16 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Friday 27 July 2012 17:12:32 Javier Cardona wrote:
>> On Fri, Jul 27, 2012 at 7:30 AM, Christian Lamparter wrote:
>> > BTW: Did you do any experiments? I.e.: Does it really
>> > work?
>>
>> Basic peering and pinging with ath9k_htc seems to work.
>> We only have one of these cards, so we cannot run our
>> full test suite.  Testing will continue when we
>> receive more cards.
>
> Ok, thanks. I'll take care of updating the information
> on the wiki now.
>
> Regards,
>         Chr



-- 
Javier Lopez
Software Engineer
cozybit Inc.
