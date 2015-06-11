Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbbFKKtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 06:49:17 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id D1C303AD50D
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 10:49:17 +0000 (UTC)
Received: from localhost (dhcp-27-216.brq.redhat.com [10.34.27.216])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t5BAnHH2004336
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 06:49:17 -0400
Date: Thu, 11 Jun 2015 12:49:09 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2800: fix assigning same WCID for different stations
Message-ID: <20150611104908.GA18173@redhat.com> (sfid-20150611_124922_260584_BC1D5B6B)
References: <1433946037-11347-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433946037-11347-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2015 at 04:20:37PM +0200, Stanislaw Gruszka wrote:
> On some hardware reading WCID entries table results getting 0xff
> numbers, no matter of value written there before. This cause assigning
> the same WCID for different stations and makes not possible to connect
> to more than one station.

This fix is incomplete, I'll send second patch.

Stanislaw

