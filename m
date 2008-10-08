Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57130 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbYJHUEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 16:04:20 -0400
Date: Wed, 8 Oct 2008 16:03:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Rami Rosen <ramirose@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH ] mac80211: fix wrong link typo in mac80211_hwsim
	documentation.
Message-ID: <20081008200334.GE32472@tuxdriver.com> (sfid-20081008_220422_309909_E0BA1E3E)
References: <eb3ff54b0810080243r416b8413uf2e12f51c309a8b7@mail.gmail.com> <1223459201.3618.49.camel@johannes.berg> <20081008161834.GL4941@jm.kir.nu> <20081008190109.GC32472@tuxdriver.com> <20081008193754.GM4941@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081008193754.GM4941@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2008 at 10:37:54PM +0300, Jouni Malinen wrote:
> On Wed, Oct 08, 2008 at 03:01:09PM -0400, John W. Linville wrote:
> 
> > Well I might be OK with that -- but are you (and Johannes) ready
> > to deal with the various "ap mode doesn't work with my hostapd
> > configuration" problems?
> 
> I think that that is a better and more productive problem to handle
> assuming the issues are indeed because of something missing from
> cfg80211 configuration. I'm supposed to make sure that everything needed
> is there anyway and getting additional people testing various
> combinations and reporting potential problems sounds useful.

I'm inclined to agree.  I'd like it if Johannes agreed too. :-)

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
