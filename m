Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34494 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbZEEEt3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 00:49:29 -0400
Received: by fxm2 with SMTP id 2so4293571fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 21:49:27 -0700 (PDT)
Subject: RE: [ipw3945-devel] IWL3945 always reports noise levels of -127
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Cc: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <02B3067C068D0549A8CCFCB17D4D318B3569A442@orsmsx502.amr.corp.intel.com>
References: <1241213459.7082.54.camel@maxim-laptop>
	 <02B3067C068D0549A8CCFCB17D4D318B3569A43A@orsmsx502.amr.corp.intel.com>
	 <1241463816.4816.1.camel@maxim-laptop>
	 <02B3067C068D0549A8CCFCB17D4D318B3569A442@orsmsx502.amr.corp.intel.com>
Content-Type: text/plain
Date: Tue, 05 May 2009 07:49:21 +0300
Message-Id: <1241498961.4816.4.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-05-04 at 12:27 -0700, Cahill, Ben M wrote:
> 
> >-----Original Message-----
> >From: Maxim Levitsky [mailto:maximlevitsky@gmail.com] 
> >Sent: Monday, May 04, 2009 3:04 PM
> >To: Cahill, Ben M
> >Cc: iwlwifi maling list; linux-wireless
> >Subject: RE: [ipw3945-devel] IWL3945 always reports noise 
> >levels of -127
> >
> >On Mon, 2009-05-04 at 11:53 -0700, Cahill, Ben M wrote:
> >> When one of our devices cannot figure out what the actual 
> >noise level is, it reports -127.
> >> 
> >> Newer devices are better at old devices at figuring noise 
> >level.  IIRC, 3945 cannot figure noise for CCK signals, and 
> >may not be possible with OFDM as well.
> >
> >Why then it did work on older kernel ?
> >(and noise levels seemed to be correct)
> 
> Hmmm, good point, and I don't know the answer!  :-(
> 
> Guess it deserves a bugzilla.
> 
> Would you be willing to look in the source to see if you can figure out why?  Looks like a search for "noise" in iwl-3945.c will lead in the right direction.
> 
> -- Ben --

Indeed I'll do.
One thing I need to check is whether this is related to firmware, as
there was a switch to newer one.
Anyway I'll see what I can do there.

I already did look at source, and I didn't yet find anything suspicios,
I guess few printk won't hurt there.

Thanks,
	Maxim Levitsky



