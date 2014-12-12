Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33284 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967608AbaLLM4S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:56:18 -0500
Message-ID: <1418388974.2470.42.camel@sipsolutions.net> (sfid-20141212_135620_522289_F19FE48A)
Subject: Re: [PATCH v2 4/4] iw: support multiple regdom print
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 12 Dec 2014 13:56:14 +0100
In-Reply-To: <1417449224-10293-4-git-send-email-arik@wizery.com> (sfid-20141201_165351_209717_CDF765FE)
References: <1417449224-10293-1-git-send-email-arik@wizery.com>
	 <1417449224-10293-4-git-send-email-arik@wizery.com>
	 (sfid-20141201_165351_209717_CDF765FE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-01 at 17:53 +0200, Arik Nemtsov wrote:
> When a phy is given, print only its regdomain. Otherwise, use the newly
> implement dump functionality to print all regdomains in the system.

This breaks on existing kernels.

johannes

