Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19603 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233AbYB2Xly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 18:41:54 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: iwl3945 Microcode SW error, and then can't stop Rx DMA
Date: Fri, 29 Feb 2008 15:38:17 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003CAD81A@orsmsx416.amr.corp.intel.com> (sfid-20080229_234201_496937_A15F7127)
In-Reply-To: <43e72e890802281400s33c8cd6fk8835c46eaf7d00ff@mail.gmail.com>
References: <43e72e890802281400s33c8cd6fk8835c46eaf7d00ff@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Luis R. Rodriguez wrote:

> After a while of running on my iwl3945 I get the following error:
> 
> [ 8414.072734] wlan0: CTS protection disabled
> (BSSID=00:13:c4:f4:25:30) [ 8473.409534] wlan0: CTS protection
> enabled (BSSID=00:13:c4:f4:25:30) [12059.081930] iwl3945: Microcode
> SW error detected. 
> Restarting 0x82000008.
> [12059.081950] iwl3945: Error Reply type 0x00000005 cmd REPLY_TX
> (0x1C) seq 0x0000 ser 0x0000004B
> [12060.076397] iwl3945: Can't stop Rx DMA.
> 
> I then have to remove the module and add it back. Haven't been able to
> replicate it again, but will let you know once I do see it again. This
> is running the latest pull from wireless-testing.git.

If you can reproduce it, please have the driver loaded with debugging
(debug=0x43fff). This will cause the microcode event log to be dumped to
the screen and we can then pinpoint what caused the microcode to
complain.

Thanks

Reinette
