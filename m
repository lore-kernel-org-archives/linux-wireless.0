Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab0JDLVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 07:21:43 -0400
Subject: Re: [PATCH v3] mac80211: Add WME information element for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20101004021730.3870.14677.stgit@tt-desk>
References: <20101004021730.3870.14677.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 13:21:40 +0200
Message-ID: <1286191300.3620.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 11:17 +0900, Bruno Randolf wrote:
> Enable WME QoS in IBSS mode by adding a WME information element to beacons and
> probe respones and by checking for it and marking stations as WME capable if it
> is present.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> 
> ---
> v3: use GFP_ATOMIC and re-organize nesting of "if" statements. allthough in
> practice we would probaby always have the rates element i think it's more
> correct to code it like this.

You're probably right, but shouldn't that be a separate patch? It
doesn't relate to WME at all, afaict.

johannes

