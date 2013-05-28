Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921Ab3E1Mih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 08:38:37 -0400
Message-ID: <1369744712.8548.3.camel@jlt4.sipsolutions.net> (sfid-20130528_143845_432336_5C083C37)
Subject: Re: [PATCH v2 1/3] cfg80211: support an active monitor interface
 flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 May 2013 14:38:32 +0200
In-Reply-To: <51A4A044.3030109@openwrt.org>
References: <1369738914-34367-1-git-send-email-nbd@openwrt.org>
	 <1369741810.8548.1.camel@jlt4.sipsolutions.net>
	 <51A4A044.3030109@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-05-28 at 14:17 +0200, Felix Fietkau wrote:
> On 2013-05-28 1:50 PM, Johannes Berg wrote:
> > On Tue, 2013-05-28 at 13:01 +0200, Felix Fietkau wrote:
> >> An active monitor interface is one that is used for communication (via
> >> injection). It is expected to ACK incoming unicast packets. This is
> >> useful for running various 802.11 testing utilities that associate to an
> >> AP via injection and manage the state in user space.
> > 
> > Applied 1 and 2.
> > 
> > Allowing MAC address duplication seems a bit strange, but I guess it
> > simplifies things for users?
> It is allowed only for non-active monitor interfaces, which previously
> did not use ieee80211_verify_mac and ignores the configured MAC address
> anyway.

Oh, that makes sense, I misread the code then.

johannes

