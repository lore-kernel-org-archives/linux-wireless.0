Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:54454 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbeIDQf5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:35:57 -0400
Message-ID: <1536063055.3940.10.camel@sipsolutions.net> (sfid-20180904_141108_012775_91A52E35)
Subject: Re: [PATCH v2 9/9] mac80211: Don't wake up from PS for offchannel TX
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@narfation.org>, Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 04 Sep 2018 14:10:55 +0200
In-Reply-To: <8536772.7SmJXvWjMu@bentobox>
References: <20180831083130.15525-1-luca@coelho.fi>
         <20180904114055.1429-1-luca@coelho.fi>
         <20180904114055.1429-10-luca@coelho.fi> <8536772.7SmJXvWjMu@bentobox>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-09-04 at 14:07 +0200, Sven Eckelmann wrote:
> On Dienstag, 4. September 2018 14:40:55 CEST Luca Coelho wrote:
> > )
> > Sender: linux-wireless-owner@vger.kernel.org
> > Precedence: bulk
> > List-ID: <linux-wireless.vger.kernel.org>
> > X-Mailing-List: linux-wireless@vger.kernel.org
> 
> Looks like the SMTP headers are broken in all your patches. Here the 
> interesting part (as received by me):

And, perhaps because of this, only patches 1-3 ended up in patchwork...
You'll have to resend again :)

johannes
