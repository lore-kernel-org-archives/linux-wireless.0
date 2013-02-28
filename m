Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55733 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760882Ab3B1WNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:13:41 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UBBjP-0003K6-Vc
	for linux-wireless@vger.kernel.org; Thu, 28 Feb 2013 23:13:40 +0100
Message-ID: <1362089617.8330.7.camel@jlt4.sipsolutions.net> (sfid-20130228_231348_327756_D045D63C)
Subject: Re: [PATCH] cfg80211: move exported event functions into nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 28 Feb 2013 23:13:37 +0100
In-Reply-To: <1361567242-18718-1-git-send-email-johannes@sipsolutions.net> (sfid-20130222_220733_722326_49E9F512)
References: <1361567242-18718-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130222_220733_722326_49E9F512)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-22 at 22:07 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This is the sort of thing gcc's LTO could do, but since
> we don't have that yet we can also do it manually. The
> advantage is reduced code, both source and binary, e.g.
> on x86-64
> 
>    text	   data	    bss	    dec	    hex	filename
>  442825	  56230	    776	 499831	  7a077	cfg80211.ko (before)
>  441585	  56230	    776	 498591	  79b9f	cfg80211.ko (after)
> 
> a reduction of ~1k.

Applied.

johannes

