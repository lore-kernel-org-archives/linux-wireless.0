Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exchange07.timesys.com ([209.114.137.35]:27206 "EHLO
	exchange07.timesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZAEUBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 15:01:25 -0500
Message-ID: <4962671C.9080605@cheek.com> (sfid-20090105_210129_794081_0C178C97)
Date: Mon, 5 Jan 2009 15:01:32 -0500
From: Joseph Cheek <joseph@cheek.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] 2.6.27 with compat-wireless-2008-12-31 stops transmitting
 every 2-3 mins
References: <495C7640.8060806@cheek.com> <20090105170432.GA6834@tesla> <49624B10.70400@cheek.com> <20090105181250.GD6834@tesla>
In-Reply-To: <20090105181250.GD6834@tesla>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

thanks, Luis!  comments below...

Luis R. Rodriguez wrote:
> Thanks for the details, this seems to be related to noise and therefore
> could be due to some issues with how we deal with ANI. We will have to
> try to reproduce this ourselves now and try to fix it.
>   

great!  i wish you luck!  would it help it i try the same test with the
problematic box right next to the AP?  I could move it upstairs to the
same room and retry an SCP or video serve.  not sure if that would give
you more useful data or not, but i can certainly move it.

if the box were quiet enough, i would keep it in the same room and just
connect via ethernet 8-).

>> I can try anything you need me to with respect to ath9k drivers or
>> kernels.  does it matter if bluetooth and/or ipv6 is enabled?  both are
>> enabled on this box but not on my laptop?
>>     
>
> Anything communication on the same spectrum affects your 802.11 connection,
> so using the microwave oven, using bluetooth, or a 2.4 GHz home phone should
> affet your connection. Not sure the freq used by Xbox / PS3 controllers...
> Bluetooth particularly should affect your 802.11 connection and we only recently
> added bluetooth coexistance to help with this but this is only available for
> more modern cards so your card does not have this feature.
>
> If you are using bluetooth then it should affect your connection if using the
> 2.4 GHz spectrum on your wirless AP.
>   

I didn't actually have the bluetooth in use, just the module built.  so
that might not be the problem.  the DIR-655 will do 5MHz only if it's in
n-only mode, and I have too many g devices in the house to want to
replace them all 8-).

>   Luis
>   
