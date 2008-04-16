Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:40459 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYDPTsW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 15:48:22 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JmDcC-0000ZI-Sd
	for linux-wireless@vger.kernel.org; Wed, 16 Apr 2008 19:48:21 +0000
Received: from 84-203-37-37.mysmart.ie ([84.203.37.37])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 19:48:20 +0000
Received: from furlongm by 84-203-37-37.mysmart.ie with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 19:48:20 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: RE:  iwl3945 problem with 2.6.25-rc9
Date: Wed, 16 Apr 2008 20:48:05 +0100
Message-ID: <fu5l5r$pm8$1@ger.gmane.org> (sfid-20080416_204831_508099_8981F9AC)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> <fu5iel$c45$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 April 2008 20:01 in <fu5iel$c45$1@ger.gmane.org>, Marcus
Furlong wrote:

> On Wednesday 16 April 2008 19:28 in
>
<D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>,
> Chatre, Reinette wrote:
> 
>> Looks like the device is being brought up and down a lot ... are you
>> perhaps running wpa_supplicant or some other user application that is
>> doing this? Could you please give more information about what you were
>> doing when these errors started to appear?
> 
> Yes, wpa_supplicant is running as part of the boot process. Should I use
> some other application? (Do wireless-tools support WPA?) Or should I just
> load the module on it's own and give the dmesg output from that?

Here is the output from the module loading without wpa_supplicant, then me
reloading it with debug flags, and running ifconfig wlan0 and iwlist
scanning. Still some Microcode SW and FW errors in there, but there's a lot
less noise.

https://www.cs.tcd.ie/~furlongm/iwlwifi/iwl3945-output-no-wpasupplicant.bz2

Marcus.

