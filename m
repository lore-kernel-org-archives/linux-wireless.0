Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38039 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbbKZQow (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 11:44:52 -0500
Message-ID: <1448556286.2167.20.camel@sipsolutions.net> (sfid-20151126_174454_564214_F73EE43A)
Subject: Re: [PATCH] cfg80211: ocb: Fix null pointer deref if join_ocb is
 unimplemented
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Thu, 26 Nov 2015 17:44:46 +0100
In-Reply-To: <1447102929-8906-1-git-send-email-ola1olsson@gmail.com> (sfid-20151109_220218_957818_4A103F31)
References: <1447102929-8906-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151109_220218_957818_4A103F31)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied, but only to mac80211-next as it's not really relevant - all
drivers actually advertising OCB mode (should) have the pointer, and
the iftype is checked here.

johannes
