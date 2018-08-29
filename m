Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:35700 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbeH2Kwh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 06:52:37 -0400
Message-ID: <1535525825.5215.1.camel@sipsolutions.net> (sfid-20180829_085720_148158_0E458EE3)
Subject: Re: [PATCH] mac80211: do not aggregate frames if max_frags is set
 to one
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, sara.sharon@intel.com
Date: Wed, 29 Aug 2018 08:57:05 +0200
In-Reply-To: <CAJ0CqmWLw11bmofttBfJQmNkCVhz-N3K9ah2HJkTbjZ6EDf-Xg@mail.gmail.com> (sfid-20180828_234116_503513_760A1610)
References: <cover.1535489707.git.lorenzo.bianconi@redhat.com>
         <d67c1a6772d46f449dbb74d61ddf4d80dee7a350.1535489707.git.lorenzo.bianconi@redhat.com>
         <1535490861.20033.8.camel@sipsolutions.net>
         <CAJ0CqmWLw11bmofttBfJQmNkCVhz-N3K9ah2HJkTbjZ6EDf-Xg@mail.gmail.com>
         (sfid-20180828_234116_503513_760A1610)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-28 at 23:41 +0200, Lorenzo Bianconi wrote:

> Assuming the A-MSDU subframe is composed by two packets, the last one
> must not contain padding, is my understanding correct?

Yes. More generally, assuming the A-MSDU subframe is composed of *any
number of* packets, the last one must not contain padding :)

> > My colleague Sara (CC'ed now) has a patch to fix all of this (we just
> > did that this morning). I'll send it out tomorrow morning. Can I bother
> > you to try that?
> > 
> 
> Sure, no worries :)

Thanks, patch coming up in a second.

> > We'd have to fix the first point independently though, or I guess we can
> > roll that into our bugfix too, which would you prefer?
> > 
> > johannes
> > 
> 
> If the patch is already done I can add the fix for the first point on
> top of it, does it sound good?

Perfect.

johannes
