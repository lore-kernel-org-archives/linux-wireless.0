Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63087 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZEDT1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 15:27:43 -0400
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 4 May 2009 12:27:23 -0700
Subject: RE: [ipw3945-devel] IWL3945 always reports noise levels of -127
Message-ID: <02B3067C068D0549A8CCFCB17D4D318B3569A442@orsmsx502.amr.corp.intel.com>
References: <1241213459.7082.54.camel@maxim-laptop>
	 <02B3067C068D0549A8CCFCB17D4D318B3569A43A@orsmsx502.amr.corp.intel.com>
 <1241463816.4816.1.camel@maxim-laptop>
In-Reply-To: <1241463816.4816.1.camel@maxim-laptop>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 

>-----Original Message-----
>From: Maxim Levitsky [mailto:maximlevitsky@gmail.com] 
>Sent: Monday, May 04, 2009 3:04 PM
>To: Cahill, Ben M
>Cc: iwlwifi maling list; linux-wireless
>Subject: RE: [ipw3945-devel] IWL3945 always reports noise 
>levels of -127
>
>On Mon, 2009-05-04 at 11:53 -0700, Cahill, Ben M wrote:
>> When one of our devices cannot figure out what the actual 
>noise level is, it reports -127.
>> 
>> Newer devices are better at old devices at figuring noise 
>level.  IIRC, 3945 cannot figure noise for CCK signals, and 
>may not be possible with OFDM as well.
>
>Why then it did work on older kernel ?
>(and noise levels seemed to be correct)

Hmmm, good point, and I don't know the answer!  :-(

Guess it deserves a bugzilla.

Would you be willing to look in the source to see if you can figure out why?  Looks like a search for "noise" in iwl-3945.c will lead in the right direction.

-- Ben --

>
>Regards,
>	Maxim Levitsky
>
>