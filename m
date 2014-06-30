Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:39736 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaF3Jzh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 05:55:37 -0400
Date: Mon, 30 Jun 2014 11:55:09 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Victor <silentworks@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Setup of wireless AP using an intel 7260-ac on 5Ghz+ band, linux
 3.15.1 (was: No channels available (no IR) in 5Ghz band for intel 7260-ac
Message-ID: <20140630095508.GA23387@sig21.net> (sfid-20140630_115541_456842_EE8BA7B9)
References: <CANUX_P3+bvv_TBVAR2dto+pYAQWdx-49cVbG_1gY8Qun_=cD5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P3+bvv_TBVAR2dto+pYAQWdx-49cVbG_1gY8Qun_=cD5Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

On Tue, Jun 24, 2014 at 03:50:43PM +0300, Emmanuel Grumbach wrote:
> >> On 06/24/2014 03:50 AM, Luis R. Rodriguez wrote:
> >>> On Mon, Jun 23, 2014 at 10:55:48PM +0200, Victor wrote:
> >>>> Hello, first of all i'm not sure if this is the proper place to ask
> >>>> since it seems mostly dev-related, but i have been looking everywhere
> >>>> trying to find a solution without luck, so i'm not sure if i
> >>>> encountered some kind of bug.
> >>>>
> >>>> Context: Setup of wireless AP using an intel 7260-ac on 5Ghz+ band, linux 3.15.1
> >>
> >> This configuration is not supported.
> >
> > Do you know why? it is supported in other kernel version?, i got the
> > device mainly for to be used as 802.11ac AP  :/, on the product brief
> > they state it is designed for AP mode
> > http://www.intel.es/content/dam/www/public/us/en/documents/product-briefs/dual-band-wireless-ac-7260-bluetooth-brief.pdf,
> > and in iw it appears as supported too
> 
> AP mode is supported - not on 5.2 GHz band.

Just out of curiosity, may I ask why?  Shouldn't regdb/crda allow
you to support it?

Thanks,
Johannes
