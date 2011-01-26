Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab1AZVzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 16:55:41 -0500
Subject: Re: [PATCH v2 2/6] nl80211: Pass probe response data to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTimTASMMUhofp=1o=Z6-dY7v8T8uoNLbqYK4TStv@mail.gmail.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
	 <1295816579-28925-3-git-send-email-arik@wizery.com>
	 <1295868924.3639.2.camel@jlt3.sipsolutions.net>
	 <AANLkTinJo7EV7zr=Z6oN3M2X3=gcv1W8G7cpbHPPNs=0@mail.gmail.com>
	 <1295950325.3650.5.camel@jlt3.sipsolutions.net>
	 <AANLkTin49svPAzuhH-ENdzoa4FnTRyOeizKrTLNYLOeu@mail.gmail.com>
	 <1296030720.3635.14.camel@jlt3.sipsolutions.net>
	 <AANLkTimTASMMUhofp=1o=Z6-dY7v8T8uoNLbqYK4TStv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 22:55:40 +0100
Message-ID: <1296078940.3635.42.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 23:51 +0200, Arik Nemtsov wrote:

> > What's wrong with putting it in the same place as the SSID?
> 
> Just put it as a pointer inside ieee80211_bss_conf? (It will still
> have to be RCU managed and all).
> About nl80211 API - I tried making it as similar as possible to the
> way the beacon works, but I guess I can pass it with bss_parameters as
> well.

Ok. Let me look at it again tomorrow.

johannes

