Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:58447 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752174AbeCXXC1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 19:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <e31eb13b-598b-e7c7-607b-c98664818563@lwfinger.net>
References: <20180324041027.6498-1-quytelda@tamalin.org> <e31eb13b-598b-e7c7-607b-c98664818563@lwfinger.net>
From: Quytelda Kahja <quytelda@tamalin.org>
Date: Sat, 24 Mar 2018 16:02:24 -0700
Message-ID: <CAFLvi20sgO4aKTLYutvwUr5aN9TLaqLWVghC9Y9MrKZvcixAYA@mail.gmail.com> (sfid-20180325_000243_986718_CE4BD109)
Subject: Re: [PATCH 1/3] ieee80211: Replace bit shifts with the BIT() macro
 for WLAN_CAPABILITY_*.
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "document" refers to the file in which the changes were made
('include/linux/ieee80211.h').

I tend to try to split my commits into the smallest logically related
changes possible, hence the three patch series.  This particular case
may be a little on the extreme side, but if the maintainer desires,
they can always squash them together or ask me to resubmit as one
patch.

On 3/24/18, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 03/23/2018 11:10 PM, Quytelda Kahja wrote:
>> It is neater and more consistent with the rest of the document to use the
>> BIT() macro from 'linux/bitops.h' to define the WLAN_CAPABILITY_*
>> bitmasks.  In the case of WLAN_CAPABILITY_DMG_TYPE_{IBSS, PBSS, AP},
>> bitshifting integers by 0 does nothing, so there is no reason to do it in
>> the code; replace these values with plain integers.
>>
>> Signed-off-by: Quytelda Kahja <quytelda@tamalin.org>
>
> In the commit message for all of these, what is the "document" to which you
> refer?
>
> I'm not quite sure why you split these changes into 3 parts, but I guess
> that is OK.
>
> Larry
>
-- 
Thank you,
Quytelda Kahja
