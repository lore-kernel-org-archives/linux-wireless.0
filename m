Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39919 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbeH2ORi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 10:17:38 -0400
Received: by mail-wm0-f67.google.com with SMTP id q8-v6so4966276wmq.4
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2018 03:21:25 -0700 (PDT)
Date: Wed, 29 Aug 2018 12:21:22 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, sara.sharon@intel.com
Subject: Re: [PATCH] mac80211: do not aggregate frames if max_frags is set to
 one
Message-ID: <20180829102121.GB2488@localhost.localdomain> (sfid-20180829_122129_332052_595EA17E)
References: <cover.1535489707.git.lorenzo.bianconi@redhat.com>
 <d67c1a6772d46f449dbb74d61ddf4d80dee7a350.1535489707.git.lorenzo.bianconi@redhat.com>
 <1535490861.20033.8.camel@sipsolutions.net>
 <CAJ0CqmWLw11bmofttBfJQmNkCVhz-N3K9ah2HJkTbjZ6EDf-Xg@mail.gmail.com>
 <1535525825.5215.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1535525825.5215.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, 2018-08-28 at 23:41 +0200, Lorenzo Bianconi wrote:
> 
> > Assuming the A-MSDU subframe is composed by two packets, the last one
> > must not contain padding, is my understanding correct?
> 
> Yes. More generally, assuming the A-MSDU subframe is composed of *any
> number of* packets, the last one must not contain padding :)
> 
> > > My colleague Sara (CC'ed now) has a patch to fix all of this (we just
> > > did that this morning). I'll send it out tomorrow morning. Can I bother
> > > you to try that?
> > > 
> > 
> > Sure, no worries :)
> 
> Thanks, patch coming up in a second.
> 
> > > We'd have to fix the first point independently though, or I guess we can
> > > roll that into our bugfix too, which would you prefer?
> > > 
> > > johannes
> > > 
> > 
> > If the patch is already done I can add the fix for the first point on
> > top of it, does it sound good?
> 
> Perfect.

Ok, I will apply it on top of Sara's patch and send it later today.

Regards,
Lorenzo

> 
> johannes
