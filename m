Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab3CDPgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:36:03 -0500
Message-ID: <1362411359.21028.26.camel@jlt4.sipsolutions.net> (sfid-20130304_163607_563411_AB80A724)
Subject: Re: [PATCH] mac80211: don't apply HT overrides to TDLS peers
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com
Date: Mon, 04 Mar 2013 16:35:59 +0100
In-Reply-To: <1362134689-3483-1-git-send-email-johannes@sipsolutions.net> (sfid-20130301_114459_830753_BB7E25BA)
References: <1362134689-3483-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130301_114459_830753_BB7E25BA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-01 at 11:44 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The HT overrides are intended only for the connection
> to the AP, not for any other purpose. Therefore, don't
> apply them to TDLS peers that are also stations added
> to a managed station interface.

Applied.

johannes

