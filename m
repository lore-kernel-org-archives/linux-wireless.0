Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45912 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726704AbeHaXL1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 19:11:27 -0400
Message-ID: <3cd29c36d77eab676c60ee179c4d06ce83ee8692.camel@coelho.fi> (sfid-20180831_210306_597616_65612C0F)
From: Luca Coelho <luca@coelho.fi>
To: Peter Oh <peter.oh@bowerswilkins.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Fri, 31 Aug 2018 22:02:29 +0300
In-Reply-To: <54391176-d540-9665-a51f-06eb75a7376f@bowerswilkins.com>
References: <20180831083130.15525-1-luca@coelho.fi>
         <20180831083130.15525-29-luca@coelho.fi>
         <54391176-d540-9665-a51f-06eb75a7376f@bowerswilkins.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 28/28] mac80211: Don't wake up from PS for offchannel TX
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-08-31 at 11:21 -0700, Peter Oh wrote:
> 
> On 08/31/2018 01:31 AM, Luca Coelho wrote:
> > )
> > 
> > From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> > 
> > Otherwise the offchannel frame might be queued due to
> > IEEE80211_QUEUE_STOP_REASON_PS and later dropped (in
> > ieee80211_tx_frags()).  Anyway, it doesn't make much sense to wake
> > up
> > the device during ROC.
> > 
> > Signed-off-by: Andrei Otcheretianski <
> > andrei.otcheretianski@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > 
> 
> Please write a cover letter that explains what this patch series is 
> trying to do.
> 28 patches are too many to catch the purpose at once.

There's no single thing we are trying to do.  This is from internal
development and I publish them for the mainline.   This is how we have
been working.  I just put them all together for easier tracking, you
can consider every patch as if they were sent out individually.


--
Cheers,
Luca.
