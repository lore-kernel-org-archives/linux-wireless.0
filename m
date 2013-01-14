Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab3ANQq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 11:46:58 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TunBY-0003Rw-B2
	for linux-wireless@vger.kernel.org; Mon, 14 Jan 2013 17:46:56 +0100
Message-ID: <1358182036.4666.0.camel@jlt4.sipsolutions.net> (sfid-20130114_174702_008664_C15F5927)
Subject: Re: [RFC] mac80211: allow drivers to access IPv6 information
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 14 Jan 2013 17:47:16 +0100
In-Reply-To: <1358173010-16985-1-git-send-email-johannes@sipsolutions.net> (sfid-20130114_151631_494051_DB12C072)
References: <1358173010-16985-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130114_151631_494051_DB12C072)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-14 at 15:16 +0100, Johannes Berg wrote:

> +#ifdef CONFIG_IPV6

All those need to be

#if IS_ENABLED(IPV6)

johannes

