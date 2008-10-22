Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59094 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbYJVTg1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:36:27 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 12:36:27 -0700
Date: Wed, 22 Oct 2008 05:36:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wireless: fix regdom passing semantics
Message-ID: <20081022123621.GJ6190@tesla> (sfid-20081022_213630_900121_C24B77DC)
References: <1224579720.5521.2.camel@johannes.berg> <20081022113751.GD6190@tesla> <1224701263.30459.45.camel@johannes.berg> <1224701394.30459.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224701394.30459.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 11:49:54AM -0700, Johannes Berg wrote:
> The regdom struct is given to the core, so it might as well
> free it in error conditions

> the current documentation for
> regulatory_hint doesn't note that you need to free it on errors
> anyway.

This last part is not accurate, typo again?

  Luis
