Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1DXIPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 04:15:52 -0400
Subject: Re: [PATCH v2] 802.11n frame injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <matteo@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTikBEs7aWZR+UovtpwYVPJfZjHEhgw@mail.gmail.com>
References: <BANLkTikBEs7aWZR+UovtpwYVPJfZjHEhgw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 10:15:49 +0200
Message-ID: <1303632949.3795.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-22 at 18:34 +0200, Matteo Croce wrote:
> This patch allows to set the tx rate and retries when injecting,
> and report correct MCS information on received frames.

This description is wrong. It doesn't touch rx.c, does it?

johannes

