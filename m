Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab3A1KCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 05:02:40 -0500
Date: Mon, 28 Jan 2013 11:02:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] iwlegacy: fix antenna bitmask
Message-ID: <20130128100229.GB2316@redhat.com> (sfid-20130128_110244_037029_EC1E42A7)
References: <E1TzDQW-0001Fa-7P@debian64.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E1TzDQW-0001Fa-7P@debian64.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 26, 2013 at 10:19:35PM +0100, Christian Lamparter wrote:
> This patch is based on "iwlwifi: fix antenna bitmask".
> (362b0563b28506d53)
> 
> Like the new iwlagn devices, the old 4965N device only
> supports a maximum of three antennas. Hence only three
> bits are used, the fourth bit is likely the A-MPDU
> indicator.
> 
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

ACK

