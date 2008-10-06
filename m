Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46167 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYJFMgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 08:36:13 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223296221.15196.6.camel@johannes.berg>
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
	 <1221184060.11498.3.camel@californication>
	 <1221185432.6695.0.camel@californication>
	 (sfid-20080912_041007_653566_F8146EC3)  <1223296221.15196.6.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 14:36:32 +0200
Message-Id: <1223296592.11272.163.camel@violet.holtmann.net> (sfid-20081006_143617_999647_249E9C15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > I take this back. It took a couple of hours, but it crashed again.
> 
> Do you have 64k pages enabled? My issue goes away entirely when I
> disable 64k pages.

so the initial issue was a BUG_ON when the ucode reports back an
unsupported event. That should have been fixed by now since we just
can't crash the whole kernel, because some piece of firmware acts bogus
now and then. However there seems to be some other issues with me
running a 64-bit OS and connecting to an N-capable access point.

Regards

Marcel


