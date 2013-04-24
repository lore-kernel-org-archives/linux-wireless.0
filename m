Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sipsolutions.net ([144.76.43.152]:50075 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab3DXK4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 06:56:51 -0400
Message-ID: <1366801001.11111.8.camel@jlt4.sipsolutions.net> (sfid-20130424_125654_796214_10759482)
Subject: Re: [PATCH] mac80211_hwsim: correctly register the platform driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: martin.pitt@ubuntu.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, dcbw@redhat.com
Date: Wed, 24 Apr 2013 12:56:41 +0200
In-Reply-To: <1366778405-7584-1-git-send-email-sasha.levin@oracle.com>
References: <1366778405-7584-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-24 at 00:40 -0400, Sasha Levin wrote:
> Not registering a platform_driver would make us access garbage
> when the platform callbacks under driver_register() kicks in.

Applied, thanks.

johannes

