Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46564 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727126AbeIDQik (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:38:40 -0400
Message-ID: <819f7fda600ad1a2e0cca575b88ca0e97f5512b2.camel@coelho.fi> (sfid-20180904_141350_287184_DCED0943)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
        Sven Eckelmann <sven@narfation.org>
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Tue, 04 Sep 2018 15:13:44 +0300
In-Reply-To: <1536063055.3940.10.camel@sipsolutions.net>
References: <20180831083130.15525-1-luca@coelho.fi>
         <20180904114055.1429-1-luca@coelho.fi>
         <20180904114055.1429-10-luca@coelho.fi> <8536772.7SmJXvWjMu@bentobox>
         <1536063055.3940.10.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 9/9] mac80211: Don't wake up from PS for offchannel TX
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-09-04 at 14:10 +0200, Johannes Berg wrote:
> On Tue, 2018-09-04 at 14:07 +0200, Sven Eckelmann wrote:
> > On Dienstag, 4. September 2018 14:40:55 CEST Luca Coelho wrote:
> > > )
> > > Sender: linux-wireless-owner@vger.kernel.org
> > > Precedence: bulk
> > > List-ID: <linux-wireless.vger.kernel.org>
> > > X-Mailing-List: linux-wireless@vger.kernel.org
> > 
> > Looks like the SMTP headers are broken in all your patches. Here
> > the 
> > interesting part (as received by me):
> 
> And, perhaps because of this, only patches 1-3 ended up in
> patchwork...
> You'll have to resend again :)

Crap! This happened once before (i.e. the hostname where SA is running
was corrupted), but it seemed to be working again (seems like I believe
in magic).

Thanks for figuring it out! I'll take a look at my server config.

--
Cheers,
Luca.
