Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1AZIcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 03:32:04 -0500
Subject: Re: [PATCH v2 2/6] nl80211: Pass probe response data to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTin49svPAzuhH-ENdzoa4FnTRyOeizKrTLNYLOeu@mail.gmail.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
	 <1295816579-28925-3-git-send-email-arik@wizery.com>
	 <1295868924.3639.2.camel@jlt3.sipsolutions.net>
	 <AANLkTinJo7EV7zr=Z6oN3M2X3=gcv1W8G7cpbHPPNs=0@mail.gmail.com>
	 <1295950325.3650.5.camel@jlt3.sipsolutions.net>
	 <AANLkTin49svPAzuhH-ENdzoa4FnTRyOeizKrTLNYLOeu@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 09:32:00 +0100
Message-ID: <1296030720.3635.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 08:00 +0200, Arik Nemtsov wrote:

> >> > Why use a separate command for this, and not do it like the SSID? I also
> >>
> >> Its only relevant to AP-mode (at least for now) so bss_conf didn't
> >> seem appropriate.
> >> Also since its a dynamically allocated buffer it should be protected by RCU.
> >
> > But all that is unrelated to the nl80211 API, no? Also the SSID already
> > uses bss_conf too, and it's AP mode too...
> 
> Do you have a preferred alternative?

What's wrong with putting it in the same place as the SSID?

johannes

