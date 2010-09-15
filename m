Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:49213 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab0IOWDr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 18:03:47 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 15:03:41 -0700
Date: Wed, 15 Sep 2010 15:03:45 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH 2/3] compat-wireless: make patch apply again.
Message-ID: <20100915220345.GD1734@tux>
References: <1284583415-11506-1-git-send-email-hauke@hauke-m.de>
 <1284583415-11506-2-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1284583415-11506-2-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 01:43:34PM -0700, Hauke Mehrtens wrote:
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks! Applied the first two patches, the carl9170 requires
a bit more work to ensure we don't oops people's old kernels
who require some extra version fixes.

  Luis
