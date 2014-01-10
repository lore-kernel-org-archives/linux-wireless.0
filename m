Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAJIlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 03:41:55 -0500
Message-ID: <1389343308.4507.0.camel@jlt4.sipsolutions.net> (sfid-20140110_094158_424163_C2280706)
Subject: Re: [PATCH v2] ieee80211: add definition for WAPI key len
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org, Avinash Patil <patila@marvell.com>
Date: Fri, 10 Jan 2014 09:41:48 +0100
In-Reply-To: <1389319691-19818-1-git-send-email-bzhao@marvell.com>
References: <1389319691-19818-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-09 at 18:08 -0800, Bing Zhao wrote:

> +	WLAN_KEY_LEN_WAPI = 32,

I think that should be SMS4, since that's the cipher name.

johannes

