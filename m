Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab1GNJuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 05:50:16 -0400
Subject: Re: [PATCH 1/5] mac80211: give if_mesh a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1310600747-9583-2-git-send-email-thomas@cozybit.com> (sfid-20110714_014631_631390_BB120B5C)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-2-git-send-email-thomas@cozybit.com>
	 (sfid-20110714_014631_631390_BB120B5C)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 11:50:11 +0200
Message-ID: <1310637011.3874.0.camel@jlt3.sipsolutions.net> (sfid-20110714_115020_227986_1B5AE5DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:
> Maintain a mesh beacon in the mesh interface like the AP interface does.
> This will save us some work later when Probe Responses are implemented.
> 
> Based on Javier Cardona's "mac80211: Support beacon configuration via
> nl80211 for mesh interfaces", which never made it upstream.

That makes little sense, was there a discussion, or did it just get
lost? Maybe you should resend it.

johannes

