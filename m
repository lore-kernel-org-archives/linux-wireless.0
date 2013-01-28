Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab3A1KJN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 05:09:13 -0500
Date: Mon, 28 Jan 2013 11:08:58 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] iwl4965: report A-MPDU status
Message-ID: <20130128100857.GC2316@redhat.com> (sfid-20130128_110918_188705_BBEA0F20)
References: <E1TzDQV-0001Fa-Sp@debian64.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E1TzDQV-0001Fa-Sp@debian64.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 18, 2013 at 11:47:19PM +0100, Christian Lamparter wrote:
> This patch is based on "iwlwifi: report A-MPDU status".
> (12bf6f45d1703858)
> 
> Since the firmware will give us an A-MPDU bit and
> only a single PHY information packet for all the
> subframes in an A-MPDU, we can easily report the
> minimal A-MPDU information for radiotap.
> 
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

ACK

