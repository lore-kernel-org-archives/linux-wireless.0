Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46888 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296AbbFQJJB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:09:01 -0400
Message-ID: <1434532138.1884.22.camel@sipsolutions.net> (sfid-20150617_110911_383181_841CF145)
Subject: Re: [PATCH V4] mac80211: minstrel_ht: Handle Dynamic SMPS state of
 the peer.
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Wed, 17 Jun 2015 11:08:58 +0200
In-Reply-To: <1434056692-8011-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150611_230504_777243_89D16518)
References: <1434056692-8011-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20150611_230504_777243_89D16518)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-06-12 at 02:34 +0530, Chaitanya T K wrote:
> In case of Dynamic SMPS enable RTS/CTS for all rates.

Applied. I really think you should drop the "." at the end of the
subject though :)

johannes

