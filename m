Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38391 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbbKZRzd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 12:55:33 -0500
Message-ID: <1448560529.2167.43.camel@sipsolutions.net> (sfid-20151126_185539_481123_7F4759BB)
Subject: Re: [PATCH v2 7/8] cfg80211: Add Kconfig option for ITS-G5 band
 (5.9 GHz)
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Sojka <sojkam1@fel.cvut.cz>, linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	Jan =?ISO-8859-1?Q?Kaisrl=EDk?= <kaisrja1@fel.cvut.cz>
Date: Thu, 26 Nov 2015 18:55:29 +0100
In-Reply-To: <1448303241-27747-8-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192812_681832_AF626F8A)
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
	 <1448303241-27747-8-git-send-email-sojkam1@fel.cvut.cz>
	 (sfid-20151123_192812_681832_AF626F8A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-23 at 19:27 +0100, Michal Sojka wrote:
> This option is meant for use by drivers and other subsystems to
> enable
> support for the Intelligent Transportation System (ITS-G5) band. The
> option depends on CFG80211_CERTIFICATION_ONUS as the use of this band
> is
> restricted. EU allows using it only for certain applications, USA
> require certification.

Hm. Why do we need this now? I see that you're checking it in ath9k, to
enable the "ITSG5" channels, but why wouldn't you always do that, now
that you have the extra checks with the user regdb being required and
all?

johannes
