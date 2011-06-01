Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47420 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759825Ab1FATsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 15:48:51 -0400
Date: Wed, 1 Jun 2011 16:48:58 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] bluetooth: fix sparse & gcc warnings
Message-ID: <20110601194858.GE2564@joana> (sfid-20110601_214857_086618_1C9209C1)
References: <1306911285.3867.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1306911285.3867.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

* Johannes Berg <johannes@sipsolutions.net> [2011-06-01 08:54:45 +0200]:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> sparse complains about a few things that should
> be static, and I also noticed another warning
> from gcc about a set but unused variable.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/bluetooth/l2cap_core.c  |    6 +++---
>  net/bluetooth/mgmt.c        |    2 +-
>  net/bluetooth/rfcomm/sock.c |    3 ---
>  3 files changed, 4 insertions(+), 7 deletions(-)

I applied the sparse part as set but unused variable warnings are all fixed,
thanks for the patch.

-- 
Gustavo F. Padovan
http://profusion.mobi
