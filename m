Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab1FHOoC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 10:44:02 -0400
Date: Wed, 8 Jun 2011 16:43:47 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: wireless-testing commit 891db8811 needed in -stable
Message-ID: <20110608144346.GC2283@redhat.com> (sfid-20110608_164406_198896_A66E97BB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, plese push upstream and cc stable (2.6.38.5+, 2.6.39+) commit:

commit 891db88112b604db054d9575d200271ad97634a4
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Fri May 27 08:40:24 2011 -0700

    iwlagn: send tx power command if defer cause by RXON not match

as it fix regresion (possible tx problems) introduced by my commit:

commit f844a709a7d8f8be61a571afc31dfaca9e779621
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Fri Jan 28 16:47:44 2011 +0100

    iwlwifi: do not set tx power when channel is changing

Thanks
Stanislaw
