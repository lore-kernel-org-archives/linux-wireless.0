Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab3JQO2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:28:21 -0400
Message-ID: <1382020097.14410.6.camel@jlt4.sipsolutions.net> (sfid-20131017_162824_920932_4ED00AF7)
Subject: Re: [PATCH] mac80211: Remove check for offchannel state when waking
 netdev queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Oct 2013 16:28:17 +0200
In-Reply-To: <1381871781-29128-1-git-send-email-seth.forshee@canonical.com> (sfid-20131015_231626_156971_C2E5A2F9)
References: <1381871781-29128-1-git-send-email-seth.forshee@canonical.com>
	 (sfid-20131015_231626_156971_C2E5A2F9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-15 at 16:16 -0500, Seth Forshee wrote:
> 6c17b77b67587b9f9e3070fb89fe98cef3187131 ensures that a device's
> mac80211 queues will remain stopped while offchannel. Since the
> vif can no longer be offchannel when the queues wake it's not
> necessary to check for this before waking its netdev queues.

Applied.

johannes

