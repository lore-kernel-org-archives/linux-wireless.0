Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34386 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbYJOVD0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 17:03:26 -0400
Subject: Re: iwlagn: associating with AP causes kernel hiccup
From: reinette chatre <reinette.chatre@intel.com>
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <gd5gs4$abi$1@ger.gmane.org>
References: <gd5gs4$abi$1@ger.gmane.org>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 13:59:23 -0700
Message-Id: <1224104363.19219.30.camel@rc-desk> (sfid-20081015_230352_759800_353AD9CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-15 at 19:38 +0000, Frederik Himpe wrote:
> When I associate with an AP, Linux 2.6.27 seems to "hang" for a few 
> seconds. During that time, all sound stops playing and keyboard and mouse 
> input is impossible. In the log I see this:
> 
> wlan0: authenticate with AP 00:15:f2:0a:ab:43
> wlan0: authenticate with AP 00:15:f2:0a:ab:43
> wlan0: authenticate with AP 00:15:f2:0a:ab:43
> wlan0: authenticated
> wlan0: associate with AP 00:15:f2:0a:ab:43
> wlan0: RX AssocResp from 00:15:f2:0a:ab:43 (capab=0x431 status=0 aid=2)
> wlan0: associated
> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> iwlagn 0000:0c:00.0: PCI INT A disabled
> iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwlagn 0000:0c:00.0: restoring config space at offset 0x1 (was 0x100102, 
> writing 0x100106)

Are you running wpa_supplicant and/or network manager?

Can you try testing without them?

Reinette

