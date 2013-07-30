Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab3G3Ui5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 16:38:57 -0400
Message-ID: <1375216719.8176.5.camel@jlt4.sipsolutions.net> (sfid-20130730_223859_563958_F3F5D705)
Subject: Re: Oops in nl80211_set_reg, Linux 3.10.3
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 30 Jul 2013 22:38:39 +0200
In-Reply-To: <1375214899.8176.4.camel@jlt4.sipsolutions.net> (sfid-20130730_220849_379151_0B5CC1C0)
References: <1375211931.2664.21.camel@deadeye.wl.decadent.org.uk>
	 (sfid-20130730_211910_708043_1782E991) <1375214899.8176.4.camel@jlt4.sipsolutions.net>
	 (sfid-20130730_220849_379151_0B5CC1C0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-07-30 at 22:08 +0200, Johannes Berg wrote:

> I don't see a similar issue with the other code that uses
> nl80211_fam.attrbuf

That's just because I'm blind -- it *looks* correct but isn't.. patch
coming.

johannes

