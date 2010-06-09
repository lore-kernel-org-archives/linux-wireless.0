Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27211 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab0FITKl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 15:10:41 -0400
Subject: Re: iwlagn fails to assoc with nexus one in ad-hoc mode
From: reinette chatre <reinette.chatre@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100609.103326.189711649.davem@davemloft.net>
References: <20100607.214612.26938385.davem@davemloft.net>
	 <1276102692.1835.14610.camel@rchatre-DESK>
	 <20100609.103326.189711649.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 12:10:41 -0700
Message-ID: <1276110641.1835.14891.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

On Wed, 2010-06-09 at 10:33 -0700, David Miller wrote:
> From: reinette chatre <reinette.chatre@intel.com>
> > Which hardware are you using? This information is needed to decode the
> > firmware assert you are posting.
> 
> 5300

The firmware assert you are encountering is something that we have fixed
before. This may be a new instance of it or you may not be running with
the fix. What repo/kernel version are you using for your testing?

Also, to confirm things, could you ensure driver is compiled with
CONFIG_IWLWIFI_DEBUG and load module with "modprobe iwlagn
debug=0x43fff" to get us some more data? It may help to compile mac80211
with verbose debugging (CONFIG_MAC80211_VERBOSE_DEBUG) also.

Thank you

Reinette


