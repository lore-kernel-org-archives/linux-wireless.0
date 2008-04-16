Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYDPUH5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 16:07:57 -0400
Subject: RE:  iwl3945 problem with 2.6.25-rc9
From: Dan Williams <dcbw@redhat.com>
To: Marcus Furlong <furlongm@hotmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <fu5l5r$pm8$1@ger.gmane.org>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <fu5iel$c45$1@ger.gmane.org>   <fu5l5r$pm8$1@ger.gmane.org>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 16:04:52 -0400
Message-Id: <1208376292.27708.3.camel@localhost.localdomain> (sfid-20080416_210808_753599_7F0532ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-16 at 20:48 +0100, Marcus Furlong wrote:
> On Wednesday 16 April 2008 20:01 in <fu5iel$c45$1@ger.gmane.org>, Marcus
> Furlong wrote:
> 
> > On Wednesday 16 April 2008 19:28 in
> >
> <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>,
> > Chatre, Reinette wrote:
> > 
> >> Looks like the device is being brought up and down a lot ... are you
> >> perhaps running wpa_supplicant or some other user application that is
> >> doing this? Could you please give more information about what you were
> >> doing when these errors started to appear?
> > 
> > Yes, wpa_supplicant is running as part of the boot process. Should I use
> > some other application? (Do wireless-tools support WPA?) Or should I just
> > load the module on it's own and give the dmesg output from that?
> 
> Here is the output from the module loading without wpa_supplicant, then me
> reloading it with debug flags, and running ifconfig wlan0 and iwlist
> scanning. Still some Microcode SW and FW errors in there, but there's a lot
> less noise.
> 
> https://www.cs.tcd.ie/~furlongm/iwlwifi/iwl3945-output-no-wpasupplicant.bz2

Interesting; can you run wpa_supplicant again but dump it's detailed
output using "-dddt" for us so we can see what it's doing and if it's
causing the restarts?

Dan


