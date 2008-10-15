Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5631 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbYJORpB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 13:45:01 -0400
Subject: Re: [RFC] make ieee80211 invisible
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1224006562.10113.47.camel@johannes.berg>
References: <1224006562.10113.47.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 10:37:48 -0700
Message-Id: <1224092268.19219.7.camel@rc-desk> (sfid-20081015_194520_570991_CC621143)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 19:49 +0200, Johannes Berg wrote:
> 
> This makes CONFIG_IEEE80211 invisible. The drivers that require it
> (ipw2100, ipw2200, hostap) select it, and everybody else really
> shouldn't even think about using it. Also, since there really is
> no point in compiling anything without crypto support these days,
> remove the crypto options and just enable them, leaving only the
> debugging option which only shows up when a driver is select that
> requires it. This makes it hard to enable, but most people wouldn't
> want to anyway.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---

Very good idea. Not sure if you need an ack from us for this, but you
have mine in case you do.

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you

Reinette
