Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54810 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbbFIToN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 15:44:13 -0400
Message-ID: <1433879050.1892.13.camel@sipsolutions.net> (sfid-20150609_214416_050195_57598FD4)
Subject: Re: [PATCH] mac80211: Always check rates and capabilities in mesh
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexis Green <agreen@cococorp.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jesse Jones <jjones@cococorp.com>
Date: Tue, 09 Jun 2015 21:44:10 +0200
In-Reply-To: <CAAnMG+MdokAvP4YNHnPX+o+0vi2vDfYB8Bj0x-kSci0yDa+bEg@mail.gmail.com> (sfid-20150530_002445_032562_22FECB72)
References: <CAAnMG+MdokAvP4YNHnPX+o+0vi2vDfYB8Bj0x-kSci0yDa+bEg@mail.gmail.com>
	 (sfid-20150530_002445_032562_22FECB72)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-05-29 at 15:24 -0700, Alexis Green wrote:
> In mesh mode there is a race between establishing links and processing rates
> and capabilities in beacons. This is very noticeable with slow beacons (e.g.
> beacon intervals of 1s) and manifested for us as stations using minstrel when
> minstrel_ht should be used. Fixed by changing mesh_sta_info_init so that it
> always checks rates and such if it has not already done so.
> 
> Signed-off-by: Alexis Green <agreen@cococorp.com>
> CC: Jesse Jones <jjones@cococorp.com>

This patch doesn't apply, it's line-broken and whitespace damaged.

johannes

