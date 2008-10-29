Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38641 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbYJ2XGQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 19:06:16 -0400
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
From: reinette chatre <reinette.chatre@intel.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081029215325.GA14849@isilmar.linta.de>
References: <1225145468.1115.139.camel@rc-desk>
	 <20081027230326.GA23250@isilmar.linta.de>
	 <1225154823.1115.149.camel@rc-desk>
	 <20081028194323.GA14303@isilmar.linta.de>
	 <1225225434.1115.217.camel@rc-desk> <1225235731.1369.8.camel@johannes.berg>
	 <1225236760.1115.245.camel@rc-desk>
	 <20081028233841.GA12554@isilmar.linta.de>
	 <20081029002713.GA16554@isilmar.linta.de>
	 <1225300252.1115.266.camel@rc-desk>
	 <20081029215325.GA14849@isilmar.linta.de>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 16:06:29 -0700
Message-Id: <1225321589.1115.313.camel@rc-desk> (sfid-20081030_000622_476148_2EC3563C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-29 at 14:53 -0700, Dominik Brodowski wrote:

> but could we get a more meaningful error message instead? Such as "No
> regulartory information found -- therefore the microcode fails to cooperate
> with you! Either use iw available at ... or recompile with
> CONFIG_WIRELESS_OLD_REGULATORY set to yes." ?
> 

This is not an error ... the driver sets the information according to
what it thinks is correct and then mac80211 changes it to what it thinks
is correct.
 
We are working on changes for the driver to work better with cfg80211

Reinette


