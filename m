Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8516 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZEDSxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:53:47 -0400
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 4 May 2009 11:53:39 -0700
Subject: RE: [ipw3945-devel] IWL3945 always reports noise levels of -127
Message-ID: <02B3067C068D0549A8CCFCB17D4D318B3569A43A@orsmsx502.amr.corp.intel.com>
References: <1241213459.7082.54.camel@maxim-laptop>
In-Reply-To: <1241213459.7082.54.camel@maxim-laptop>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When one of our devices cannot figure out what the actual noise level is, it reports -127.

Newer devices are better at old devices at figuring noise level.  IIRC, 3945 cannot figure noise for CCK signals, and may not be possible with OFDM as well.

-- Ben -- 

>-----Original Message-----
>From: Maxim Levitsky [mailto:maximlevitsky@gmail.com] 
>Sent: Friday, May 01, 2009 5:31 PM
>To: iwlwifi maling list
>Cc: linux-wireless
>Subject: [ipw3945-devel] IWL3945 always reports noise levels of -127
>
>This is minor, and qute old issue, but botting in ubuntu 
>kernel, 'fixes'
>it so it must be a regression.
>
>Sorry for not reporting this earlier.
>
>Best regards,
>	Maxim Levitsky
>
>
>
>---------------------------------------------------------------
>---------------
>Register Now & Save for Velocity, the Web Performance & Operations 
>Conference from O'Reilly Media. Velocity features a full day of 
>expert-led, hands-on workshops and two days of sessions from industry 
>leaders in dedicated Performance & Operations tracks. Use code 
>vel09scf 
>and Save an extra 15% before 5/3. http://p.sf.net/sfu/velocityconf
>_______________________________________________
>Ipw3945-devel mailing list
>Ipw3945-devel@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>