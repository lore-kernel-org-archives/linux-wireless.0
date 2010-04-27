Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40016 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0D0APs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 20:15:48 -0400
Date: Mon, 26 Apr 2010 20:12:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] cfg80211: add ap isolation support
Message-ID: <20100427001233.GB2079@tuxdriver.com>
References: <1272324216-73349-1-git-send-email-nbd@openwrt.org>
 <20100426232332.GA2079@tuxdriver.com>
 <4BD621FA.1000405@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4BD621FA.1000405@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 27, 2010 at 01:30:02AM +0200, Felix Fietkau wrote:
> On 2010-04-27 1:23 AM, John W. Linville wrote:
> > On Tue, Apr 27, 2010 at 01:23:35AM +0200, Felix Fietkau wrote:
> >> This is used to configure APs to not bridge traffic between connected stations.
> >> 
> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > 
> > Is this useful?
> Yes, if you have an AP with lots of users that aren't expected to
> communicate with each other (e.g. only for internet access), it can save
> a lot of airtime by not forwarding every broadcast message emitted from
> any station.
> I'm sure there are a more situations where this can be useful.

Ah, OK -- I suppose that makes sense.

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
