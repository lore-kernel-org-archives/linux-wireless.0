Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53915 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZAKNSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 08:18:10 -0500
Date: Sun, 11 Jan 2009 14:10:15 +0100
From: Andreas Mohr <andi@lisas.de>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, maximlevitsky@gmail.com, andi@lisas.de,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/2] ath5k: support LEDs on Acer Aspire One netbook
Message-ID: <20090111131015.GA31037@rhlx01.hs-esslingen.de> (sfid-20090111_141816_611159_8F013926)
References: <1230840105-30960-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1230840105-30960-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 01, 2009 at 03:01:44PM -0500, Bob Copeland wrote:
> Add vendor ID for Foxconn and use it to set the ath5k LED gpio and
> polarity for Acer branded laptops.

My LED is dead again on 2.6.29-rc1 (reason: doesn't contain this patch).

Thanks,

Andreas Mohr
