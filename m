Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58573 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbbJES4u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 14:56:50 -0400
Message-ID: <1444071403.21467.0.camel@sipsolutions.net> (sfid-20151005_205653_859652_A6715186)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Date: Mon, 05 Oct 2015 20:56:43 +0200
In-Reply-To: <wrfjk2r1b16i.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1441032517.13980.21.camel@sipsolutions.net> <wrfjmvx73u0l.fsf@redhat.com>
	 <1441120044.2441.9.camel@sipsolutions.net> <wrfj4mjcqn3x.fsf@redhat.com>
	 <wrfjvbbsp6ot.fsf@redhat.com> <1441275474.2565.18.camel@sipsolutions.net>
	 <wrfjmvx2gi0m.fsf@redhat.com>
	 <21994.26976.882903.355191@gargle.gargle.HOWL>
	 <1442508413.2821.11.camel@sipsolutions.net> <wrfjk2r1b16i.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-10-05 at 14:49 -0400, Jes Sorensen wrote:
> 
> Finally went back to look at this - I believe this is exactly what I am
> doing in the driver right now. Pulling the short_preamble info from
> BSS_CHANGED_ERP_PREAMBLE and storing it sta->drv_priv for use in the
> tx function.
> 

You can't really be doing that since you don't get a sta pointer with
BSS_CHANGED_ERP_PREAMBLE?

johannes
