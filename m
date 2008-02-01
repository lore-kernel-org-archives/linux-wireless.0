Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:8911 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758320AbYBAWiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 17:38:06 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: ipw2200 stalls on high load
Date: Fri, 1 Feb 2008 14:29:22 -0800
Message-ID: <D936D925018D154694D8A362EEB08920038F4382@orsmsx416.amr.corp.intel.com> (sfid-20080201_223827_141792_BACA0827)
In-Reply-To: <20080130225738.GB2648@Chamillionaire.breakpoint.cc>
References: <20080126132939.GA22630@Chamillionaire.breakpoint.cc> <D936D925018D154694D8A362EEB0892003800B1B@orsmsx416.amr.corp.intel.com> <20080130225738.GB2648@Chamillionaire.breakpoint.cc>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Sebastian Siewior" <ipw+2200@ml.breakpoint.cc>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	"James Ketrenos" <jketreno@linux.intel.com>,
	<linux-wireless@vger.kernel.org>,
	<ipw2100-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Sebastian Siewior wrote:

> * Chatre, Reinette | 2008-01-28 10:40:16 [-0800]:
> 
>> On ,Sebastian Siewior wrote:
>> 
>>> Hello,
>>> 
>>> my wireless connection stalls after like 5 seconds once the
>>> downloading performance passes around 600 KiB/sec. I noticed in
>>> dmesg the following:
>>>> ipw2200: Firmware error detected.  Restarting.
>> 
>> Could you please submit a bug at http://www.bughost.org to enable us
>> to track this problem?
> Sure. #1487 looks very close. The firmware version seems to be
> different as well as the "the driver messsage". Do you want me to
> open a new one or should I follow-up?

This bug may be similar to the bug that was fixed for the 3945 and 4965.
See the patch "iwlwifi: fix ucode assertion for RX queue overrun" for
these drivers. We need somebody to port this change to the ipw2200.
Recently there has also been talk about these issues on the
ipw3945-devel mailing list.

Please do add any information you deem important to the bug report.
Please follow the same debug level as the previous comments to that bug.

Unfortunately we are focused on the iwlwifi driver right now - we hope
we get around to this in a reasonable time. 

Reinette
