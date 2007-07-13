Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760181AbXGMSTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 14:19:43 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 1/1] mac80211: Replace overly "sticky" averaging filters for rssi, signal, noise.
Date: Fri, 13 Jul 2007 11:19:28 -0700
Message-ID: <4220499A1B034C4FA93B547BA01E1FF0017461F8@orsmsx413.amr.corp.intel.com>
In-Reply-To: <4697BC55.1080704@lwfinger.net>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Larry Finger" <larry.finger@lwfinger.net>,
	"Jiri Benc" <jbenc@suse.cz>
Cc: <benmcahill@gmail.com>, <flamingice@sourmilk.net>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> I added the wireless statistics to d80211 (it was that long 
> ago) and I used 16-point averaging based on my experiences 
> with an early version of the bcm43xx-softmac driver where the 
> rssi value was quite jittery. From a quick test on the 
> current drivers, the assumptions seem not to be valid and it 
> is quite possible that averaging may not be needed, or that 
> one can get by with a 2- or 4-point process.
> 
> My suggestion would be to circulate a trial patch with 
> averaging removed and ask for testing to see if it makes the 
> results too jumpy. I can prepare that patch if you wish.
> 
> Larry

Thanks for the history, Larry.  I'd be very happy if you did.  Thanks!

-- Ben --
> 
