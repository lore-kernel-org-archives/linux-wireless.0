Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36938 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaLQOQ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 09:16:26 -0500
Message-ID: <1418825777.2135.17.camel@sipsolutions.net> (sfid-20141217_151629_176139_B6850DA0)
Subject: Re: [PATCH v2] iw: support multiple regdom print
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 17 Dec 2014 15:16:17 +0100
In-Reply-To: <1418661863-2630-1-git-send-email-arik@wizery.com> (sfid-20141215_174426_420479_E57ECC25)
References: <1418661863-2630-1-git-send-email-arik@wizery.com>
	 (sfid-20141215_174426_420479_E57ECC25)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-15 at 18:44 +0200, Arik Nemtsov wrote:
> When a phy is given, print only its regdomain. Otherwise, use the newly
> implement dump functionality to print all regdomains in the system.

Applied.

johannes

