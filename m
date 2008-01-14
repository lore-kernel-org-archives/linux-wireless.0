Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52164 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYANSyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 13:54:11 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: iwlwifi 1.2.23 vs. kernel 2.6.23.13
Date: Mon, 14 Jan 2008 10:54:09 -0800
Message-ID: <D936D925018D154694D8A362EEB089200364DE52@orsmsx416.amr.corp.intel.com> (sfid-20080114_185413_302845_D7A796CB)
In-Reply-To: <20080113150536.GA27544@/bin/dnsdomainname>
References: <20080113150536.GA27544@/bin/dnsdomainname>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Mario Guenterberg" <mg@havelsoft.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Mario Guenterberg [mg@havelsoft.com]  wrote:

> I has tried to compile the latest stable kernel (2.6.23.13) with the
> iwlwifi-1.2.23 driver and the mac80211-10.0.4 framework. I has
> patched the kernel source tree and when I start menuconfig, it
> was fine.
> If I started to run make, nothing seems to be wrong, but the iwl3945
> module was not build. 

At this point the new mac80211 module should be built. There is no
iwl3945 in the 2.6.23 kernel so it will not be built as part of this
(the kernel build) step. After you built mac80211 in the kernel you need
to follow the installation instructions of iwl3945 to built it as a
separate module outside the kernel. Details can be found in the INSTALL
file that came with iwlwifi-1.2.23.

Reinette
