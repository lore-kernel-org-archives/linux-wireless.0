Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbcADJeZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 04:34:25 -0500
Date: Mon, 4 Jan 2016 10:33:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/3] net-iwlegacy: Refactoring for il_eeprom_init()
Message-ID: <20160104093305.GA2588@redhat.com> (sfid-20160104_103446_042817_A3037D12)
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686E13F.2010309@users.sourceforge.net>
 <5686E1D2.60107@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5686E1D2.60107@users.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 01, 2016 at 09:30:10PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 1 Jan 2016 20:54:25 +0100
> 
> Return directly if a memory allocation failed at the beginning.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

