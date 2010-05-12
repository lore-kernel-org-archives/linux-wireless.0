Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab0ELI37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 04:29:59 -0400
Subject: Re: [PATCH 1/3] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	holgerschurig@gmail.com
In-Reply-To: <20100512082325.26565.46809.stgit@tt-desk>
References: <20100512082231.26565.16730.stgit@tt-desk>
	 <20100512082325.26565.46809.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 10:29:54 +0200
Message-ID: <1273652994.3979.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-12 at 17:23 +0900, Bruno Randolf wrote:

> +	CMD(get_antenna, GET_ANTENNA);

I'm wondering ... does get_antenna really make sense as a separate
command? Seems like we could just as well report it as part of the wiphy
information dump?

johannes

