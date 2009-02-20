Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20780 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZBTDCm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 22:02:42 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 19:02:42 -0800
Date: Thu, 19 Feb 2009 19:01:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] compat-2.6: Add place holder for
	CONFIG_MAC80211_DEBUGFS in config.mk
Message-ID: <20090220030155.GF4740@tesla> (sfid-20090220_040246_335508_02EFE92E)
References: <499DA503.4070404@hauke-m.de> <43e72e890902191345r74688e72hb9181aa1e4ae25aa@mail.gmail.com> <499E1B61.20301@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <499E1B61.20301@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 19, 2009 at 06:54:25PM -0800, Larry Finger wrote:
> It is difficult to help someone debug a rate-setting problem when using
> compat-wireless because debugging is not set for mac80211. With this patch
> the place holder is in the make file even though the debug option is not
> set, and it will be easier to coach a user on turning it on.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied and new tarball regenerated.

  Luis
