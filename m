Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab1GNRRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 13:17:49 -0400
Subject: Re: [RFC 3/3] mac80211: Report 40MHz Intolerance to associated AP.
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110714171236.GB25573@vmraj-lnx.users.atheros.com>
References: <1310559873-10314-1-git-send-email-rmanohar@qca.qualcomm.com>
	 <1310559873-10314-3-git-send-email-rmanohar@qca.qualcomm.com>
	 <1310638549.3874.12.camel@jlt3.sipsolutions.net>
	 <20110714171236.GB25573@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 19:17:46 +0200
Message-ID: <1310663866.3874.28.camel@jlt3.sipsolutions.net> (sfid-20110714_191752_918751_6B48EEFE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-07-14 at 22:42 +0530, Rajkumar Manoharan wrote:

> > Heck, come to think of it, why not do this in wpa_supplicant?
> >
> I prefer to go with the common layer for both wpa_s and iw. But cfg80211
> seems to be better.

In practise, nobody uses iw to maintain connections. Anything that
cfg80211 can do, wpa_supplicant can do as well, so I don't really see
the point in pushing this into the kernel.

johannes

