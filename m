Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52249 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1FITRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 15:17:20 -0400
Subject: Re: [PATCH] cfg80211: Ignore downstream DEAUTH for authtry_bsses
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110609191327.20D2C2038D@glenhelen.mtv.corp.google.com> (sfid-20110609_211330_842374_E21EE85A)
References: <20110609191327.20D2C2038D@glenhelen.mtv.corp.google.com>
	 (sfid-20110609_211330_842374_E21EE85A)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 21:17:18 +0200
Message-ID: <1307647038.3904.0.camel@jlt3.sipsolutions.net> (sfid-20110609_211723_414508_1E592E06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-08 at 05:52 -0700, Paul Stewart wrote:
> If we receive a DEAUTH message from an AP while performing
> an AUTH request, this does not constitute a reply to our AUTH
> request.  In some cases an incoming DEAUTH may be due to the AP
> clearing out old state from a previous authentication.
> Instead we should ignore it and continue waiting for an AUTH
> response.

Ack, but you should do something about how you submit patches -- they
always end up at the bottom of my list because you're sending them with
the commit date as the email date.

johannes


