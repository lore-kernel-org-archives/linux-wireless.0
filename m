Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3BKP0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 10:26:01 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4vGZ-0004Zm-Au
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 16:25:59 +0100
Message-ID: <1360596356.8738.33.camel@jlt4.sipsolutions.net> (sfid-20130211_162606_515194_85C07F82)
Subject: Re: [RFC 1/2] cfg80211: advertise extended capabilities to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 16:25:56 +0100
In-Reply-To: <1360593979-27972-1-git-send-email-johannes@sipsolutions.net> (sfid-20130211_154630_343336_CEF16279)
References: <1360593979-27972-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130211_154630_343336_CEF16279)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 15:46 +0100, Johannes Berg wrote:

> + * @NL80211_ATTR_EXT_CAPA: Extended capabilities that the kernel driver
> + *	has and handles. The format is the same as the IE contents.

Jouni pointed out that it'd be safer to also have a mask (for those
multi-bit fields that are coming into this ...) so I've made that
change.

johannes

