Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab1DDMVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 08:21:14 -0400
Subject: Re: [PATCH v6 00/10] {mac|nl}80211: mesh security enhancements
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com
In-Reply-To: <1301690151-14979-1-git-send-email-thomas@cozybit.com>
References: <1301690151-14979-1-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 14:21:13 +0200
Message-ID: <1301919673.3870.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 13:35 -0700, Thomas Pedersen wrote:
> v6:
> - remove unneeded bits (Johannes)
> - mesh capabilities returned for a wiphy & check if wiphy supports mesh
>   authentication before joining a secure mesh (Johannes)
> 
> Javier Cardona (9):
>   nl80211: rename NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE
>   nl80211: Add userspace authentication  flag to mesh setup
>   mac80211: ignore peers if security is enabled for this mesh
>   nl80211: let userspace authenticate stations
>   mac80211: Let user space receive and send mesh auth/deauth frames
>   mac80211: ignore peer link requests from unauthenticated stations.
>   mac80211: Perform PLINK_ACTION on new station
>   nl80211: New notification to discover mesh peer candidates.
>   mac80211: send notification on new peer candidate for our secure mesh
> 
> Thomas Pedersen (1):
>   nl80211: report mesh capabilities

I don't believe this patchset works, since mac80211 doesn't set
@WIPHY_FLAG_MESH_AUTH afaict.

johannes

