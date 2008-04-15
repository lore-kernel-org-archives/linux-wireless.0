Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52236 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762087AbYDOWkI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 18:40:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Jltoo-0001Ew-LW
	for linux-wireless@vger.kernel.org; Tue, 15 Apr 2008 22:40:02 +0000
Received: from 84-203-37-37.mysmart.ie ([84.203.37.37])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 15 Apr 2008 22:40:02 +0000
Received: from furlongm by 84-203-37-37.mysmart.ie with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 15 Apr 2008 22:40:02 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: iwl3945 problem with 2.6.25-rc9
Date: Tue, 15 Apr 2008 23:24:21 +0100
Message-ID: <fu39uq$abv$1@ger.gmane.org> (sfid-20080415_234018_513094_01824FCC)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Have had a look through bugzilla and not sure if any of the existing bugs
are exactly the same as mine, so thought I'd post here first to make sure
I'm not missing anything obvious.

Kernel 2.6.25-rc9 (although the same thing seems to happen on 2.6.24
kernels, so I stuck with the ipw driver and 2.6.23 til now)
Using iwl3945 firmware 2.14.1.5

Machine doesn't associate with any AP (although it does seem to see the
closer ones) and I get lots of the following errors:

iwl3945: Microcode SW error detected.  Restarting 0x82000008.

Also, and unsure if this is related or not, the mouse and keyboard behave
erratically when the iwl3945 module is loaded. Both keyboard and mouse lock
up, but store all input in a buffer and spurt it out after a few seconds.
After between 1-10 minutes the machine hangs and the Caps Lock and Scroll
Lock lights flash on and off (not the Num Lock one though).

Dmesg log is available here using netconsole on a wired connection, up to
the point where it crashes:

https://www.cs.tcd.ie/~furlongm/iwlwifi/iwlwifi-output.bz2

I also reloaded the module with debug=0x43ffb after booting, so the output
becomes more verbose at that stage.

Marcus.



