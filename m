Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42717 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYDPTBz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 15:01:55 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JmCtD-0006Mz-7F
	for linux-wireless@vger.kernel.org; Wed, 16 Apr 2008 19:01:51 +0000
Received: from 84-203-37-37.mysmart.ie ([84.203.37.37])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 19:01:51 +0000
Received: from furlongm by 84-203-37-37.mysmart.ie with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 19:01:51 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: RE:  iwl3945 problem with 2.6.25-rc9
Date: Wed, 16 Apr 2008 20:01:31 +0100
Message-ID: <fu5iel$c45$1@ger.gmane.org> (sfid-20080416_200204_315959_1789D0E7)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 April 2008 19:28 in
<D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>,
Chatre, Reinette wrote:

> On , Marcus Furlong  wrote:
> 
>> Hi,
>> 
>> Have had a look through bugzilla and not sure if any of the
>> existing bugs
>> are exactly the same as mine, so thought I'd post here first
>> to make sure
>> I'm not missing anything obvious.
>> 
>> Kernel 2.6.25-rc9 (although the same thing seems to happen on 2.6.24
>> kernels, so I stuck with the ipw driver and 2.6.23 til now)
>> Using iwl3945 firmware 2.14.1.5
>> 
>> Machine doesn't associate with any AP (although it does seem to see
>> the closer ones) and I get lots of the following errors:
>> 
>> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
>> 
>> Also, and unsure if this is related or not, the mouse and
>> keyboard behave
>> erratically when the iwl3945 module is loaded. Both keyboard
>> and mouse lock
>> up, but store all input in a buffer and spurt it out after a
>> few seconds.
>> After between 1-10 minutes the machine hangs and the Caps Lock
>> and Scroll
>> Lock lights flash on and off (not the Num Lock one though).
>> 
>> Dmesg log is available here using netconsole on a wired
>> connection, up to
>> the point where it crashes:
>> 
>> https://www.cs.tcd.ie/~furlongm/iwlwifi/iwlwifi-output.bz2
>> 
>> I also reloaded the module with debug=0x43ffb after booting,
>> so the output
>> becomes more verbose at that stage.
> 
> Looks like the device is being brought up and down a lot ... are you
> perhaps running wpa_supplicant or some other user application that is
> doing this? Could you please give more information about what you were
> doing when these errors started to appear?

Yes, wpa_supplicant is running as part of the boot process. Should I use
some other application? (Do wireless-tools support WPA?) Or should I just
load the module on it's own and give the dmesg output from that?

Marcus.

