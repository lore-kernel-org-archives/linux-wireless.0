Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60566 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbYDPS2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 14:28:35 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE:  iwl3945 problem with 2.6.25-rc9
Date: Wed, 16 Apr 2008 11:28:34 -0700
Message-ID: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> (sfid-20080416_192843_002006_9DC5C563)
In-Reply-To: A<fu39uq$abv$1@ger.gmane.org>
References: A<fu39uq$abv$1@ger.gmane.org>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Marcus Furlong" <furlongm@hotmail.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Marcus Furlong  wrote:

> Hi,
> 
> Have had a look through bugzilla and not sure if any of the
> existing bugs
> are exactly the same as mine, so thought I'd post here first
> to make sure
> I'm not missing anything obvious.
> 
> Kernel 2.6.25-rc9 (although the same thing seems to happen on 2.6.24
> kernels, so I stuck with the ipw driver and 2.6.23 til now)
> Using iwl3945 firmware 2.14.1.5
> 
> Machine doesn't associate with any AP (although it does seem to see
> the closer ones) and I get lots of the following errors:
> 
> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> 
> Also, and unsure if this is related or not, the mouse and
> keyboard behave
> erratically when the iwl3945 module is loaded. Both keyboard
> and mouse lock
> up, but store all input in a buffer and spurt it out after a
> few seconds.
> After between 1-10 minutes the machine hangs and the Caps Lock
> and Scroll
> Lock lights flash on and off (not the Num Lock one though).
> 
> Dmesg log is available here using netconsole on a wired
> connection, up to
> the point where it crashes:
> 
> https://www.cs.tcd.ie/~furlongm/iwlwifi/iwlwifi-output.bz2
> 
> I also reloaded the module with debug=0x43ffb after booting,
> so the output
> becomes more verbose at that stage.

Looks like the device is being brought up and down a lot ... are you
perhaps running wpa_supplicant or some other user application that is
doing this? Could you please give more information about what you were
doing when these errors started to appear? 

Thank you very much for the detailed logs ... I'll pass it on to the
firmware experts.

Reinette
