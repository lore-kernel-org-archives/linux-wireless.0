Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f49.google.com ([209.85.128.49]:38061 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab3J3SpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 14:45:05 -0400
Received: by mail-qe0-f49.google.com with SMTP id a11so1092122qen.22
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 11:45:05 -0700 (PDT)
Date: Wed, 30 Oct 2013 14:43:02 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] nl80211: better document NL80211_CMD_TDLS_MGMT
Message-ID: <20131030184302.GA1026@localhost> (sfid-20131030_194519_184491_5803EF9C)
References: <1383152974-13097-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383152974-13097-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 30, 2013 at 07:09:34PM +0200, Arik Nemtsov wrote:
> + * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame. The
> + *	%NL80211_ATTR_TDLS_ACTION attribute determines the typ of frame to be

type typo there.

> + *	sent. Public Action codes (802.11-2012 8.1.5.1) will be sent as
> + *	802.11 management frames, while TDLS action codes (802.11-2012

-- 
Bob Copeland %% www.bobcopeland.com
