Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932977AbcI1RWb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 13:22:31 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Braun <michael-dev@fami-braun.de>, kvalo@codeaurora.org,
        akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        projekt-wlan@fem.tu-ilmenau.de
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on AP interfaces
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
        <wrfja8esdpcb.fsf@redhat.com>
        <1475076763.4139.42.camel@sipsolutions.net>
        <wrfj1t04c9ug.fsf@redhat.com>
        <1475077359.4139.44.camel@sipsolutions.net>
Date: Wed, 28 Sep 2016 13:22:28 -0400
In-Reply-To: <1475077359.4139.44.camel@sipsolutions.net> (Johannes Berg's
        message of "Wed, 28 Sep 2016 17:42:39 +0200")
Message-ID: <wrfjoa38aqi3.fsf@redhat.com> (sfid-20160928_192242_701594_E895E472)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:
> On Wed, 2016-09-28 at 11:39 -0400, Jes Sorensen wrote:
>
>> > No Jes, you're wrong this time - this is changing internal API so
>> > it does have to touch all users thereof.
>> 
>> Even in this case, change the individual components in individual
>> patches and post them as a set.
>
> No, still wrong - it has to be committed as a single patch so it
> doesn't break bisect.
>
>> Changes to staging needs to go in via staging, and rtl8723au is gone
>> from the staging tree.
>> 
>
> I've previously taken API change patches that touch staging, if people
> feel so inclined, and I don't think Greg will mind. I'm going to keep
> doing that unless Dave tells me he won't pull from me when I do it :)

I'll still argue this could be handled better through gradual migration
rather than one large patch that touches too many places, but if you are
willing to take it, I am not going to fight you over it :)

Jes
