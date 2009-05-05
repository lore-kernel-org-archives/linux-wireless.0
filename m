Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:37601 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbZEEOuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 10:50:40 -0400
Received: by bwz22 with SMTP id 22so1318272bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2009 07:50:39 -0700 (PDT)
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
Date: Tue, 05 May 2009 17:50:33 +0300
Message-Id: <1241535034.4816.20.camel@maxim-laptop>
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

And I do know it now (this is what I suspected...)
This is firmware issue.

I forced the driver to use older firmware iwlwifi-3945-1.ucode,
and noise levels are back.


Regards,
	Maxim Levitsky

