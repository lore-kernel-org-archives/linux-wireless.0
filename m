Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49120 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbYAYRFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 12:05:13 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: 2.6.24-rc8: iwl3945 gets stuck
Date: Fri, 25 Jan 2008 09:04:29 -0800
Message-ID: <D936D925018D154694D8A362EEB08920037FFC19@orsmsx416.amr.corp.intel.com> (sfid-20080125_170518_957528_4A5B3E3E)
In-Reply-To: <4797994C.1090900@t-online.de>
References: <4797994C.1090900@t-online.de>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Harald Dunkel" <harald.dunkel@t-online.de>,
	<linux-wireless@vger.kernel.org>
Cc: <linville@tuxdriver.com>, <dhazelton@enter.net>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On ,  Harald Dunkel wrote:

> I've got some problem with iwl3945: If I run
> 
> 	xset dpms force off
> 
> for the local display while some network traffic is running, then
> the iwl3945 gets stuck. Syslog says:
> 
> Jan 23 19:29:41 daffy kernel: iwl3945: Microcode SW error
> detected.  Restarting 0x2000008.
> Jan 23 19:29:43 daffy kernel: iwl3945: Can't stop Rx DMA.
> 

Very strange. Would it be possible to load the module with
"debug=0x43fff"? This will capture a detailed event log and error log
from uCode, so we can see what caused the uCode error.

Also, could you please open a bug in our bug tracker
(http://www.bughost.org/bugzilla/) - this will make it easier to keep
all info together and get the right people to take a look at it.

Thanks

Reinette

