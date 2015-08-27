Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35795 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbH0Rqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 13:46:54 -0400
Received: by iodt126 with SMTP id t126so66204604iod.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2015 10:46:53 -0700 (PDT)
Date: Thu, 27 Aug 2015 13:46:33 -0400
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] mac80211: implement VHT support for mesh
Message-ID: <20150827174633.GB7107@localhost> (sfid-20150827_194657_710254_0D8D9F20)
References: <1440680418-19714-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440680418-19714-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2015 at 09:00:18AM -0400, Bob Copeland wrote:
> Implement the basics required for supporting very high throughput
> with mesh: include VHT information elements in beacons, probe
> responses, and peering action frames, and check for compatible VHT
> configurations when peering.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> [resend with correct linux-wireless address]

I also messed up the numbering on the resend -- there's only one
patch here.  More coffee needed.

-- 
Bob Copeland %% http://bobcopeland.com/
