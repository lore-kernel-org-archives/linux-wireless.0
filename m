Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab1JYHZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 03:25:37 -0400
From: Johannes Berg <johannes@sipsolutions.net>
Reply-To: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>, Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/3] nl80211: Add probe response offload attribute
References: <1319313081-28722-1-git-send-email-guy@wizery.com>
	  <87zkgpbnpx.fsf@purkki.adurom.net>
In-Reply-To: <87zkgpbnpx.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8
Date: Tue, 25 Oct 2011 09:25:24 +0200
Message-Id: <1319527524.7461.2.camel@Nokia-N900-51-1> (sfid-20111025_092548_506015_1F346187)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +enum nl80211_probe_resp_offload_support_attr {
> > +    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WSC =    1<<0,
> > +    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WSC2 =    1<<1,
> > +    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P =    1<<2,
> > +};
> 
> Maybe BIT() macro (like below) would be better for consistency?

No, this header is userspace visible, so BIT isn't easily available.

johannes
