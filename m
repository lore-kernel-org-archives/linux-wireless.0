Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab0KDUwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 16:52:13 -0400
Subject: Re: [RFC 14/15] cfg80211: add ie support for periodic scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1288612336-2830-15-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-15-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 11:49:52 -0400
Message-ID: <1288885792.3659.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:
> Add an array of pointers to ie (one element for each band) and the respective
> array of ie lengths.

Shouldn't this also be exposed to userspace?

johannes

