Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:33284 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYKAQHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 12:07:07 -0400
Date: Sat, 1 Nov 2008 18:06:09 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
Subject: Re: Michael MIC failures in AP mode?
Message-ID: <20081101160609.GD4857@jm.kir.nu> (sfid-20081101_170714_534902_A9B6217D)
References: <87wsfnldq9.fsf@nokia.com> <20081101151938.GA4857@jm.kir.nu> <1225554697.3619.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1225554697.3619.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 01, 2008 at 04:51:37PM +0100, Johannes Berg wrote:

> On that matter, should we put a debugfs control knob in place to
> completely disable HW encryption in mac80211, so we don't need this
> override in all drivers?

Yes, that would probably be a good idea. There are going to be number of
cases when some combinations are not going to work (e.g., when IEEE
802.11w is added, I would expect to see some breakage..) and being able
to force software encryption per device could end up being quite useful.

-- 
Jouni Malinen                                            PGP id EFC895FA
