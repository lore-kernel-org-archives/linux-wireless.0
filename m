Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56436 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932960AbcI1Pmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 11:42:49 -0400
Message-ID: <1475077359.4139.44.camel@sipsolutions.net> (sfid-20160928_174316_571014_43FB1FF7)
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on
 AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Michael Braun <michael-dev@fami-braun.de>, kvalo@codeaurora.org,
        akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 28 Sep 2016 17:42:39 +0200
In-Reply-To: <wrfj1t04c9ug.fsf@redhat.com>
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
         <wrfja8esdpcb.fsf@redhat.com> <1475076763.4139.42.camel@sipsolutions.net>
         <wrfj1t04c9ug.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-09-28 at 11:39 -0400, Jes Sorensen wrote:

> > No Jes, you're wrong this time - this is changing internal API so
> > it does have to touch all users thereof.
> 
> Even in this case, change the individual components in individual
> patches and post them as a set.

No, still wrong - it has to be committed as a single patch so it
doesn't break bisect.

> Changes to staging needs to go in via staging, and rtl8723au is gone
> from the staging tree.
> 

I've previously taken API change patches that touch staging, if people
feel so inclined, and I don't think Greg will mind. I'm going to keep
doing that unless Dave tells me he won't pull from me when I do it :)

johannes
