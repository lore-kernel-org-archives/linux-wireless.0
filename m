Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:48839 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab1JYNUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 09:20:46 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Kalle Valo <kvalo@adurom.com>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 25 Oct 2011 15:20:04 +0200
Subject: RE: [PATCH] NFC: update to NCI spec 1.0 draft 18
Message-ID: <AC090B9732AB2B4DB7FF476E907FE660013B993A6D@dnce02.ent.ti.com> (sfid-20111025_152050_093275_76E00811)
References: <1319355971-14757-1-git-send-email-ilane@ti.com>
 <87sjmhb7j7.fsf@purkki.adurom.net>
In-Reply-To: <87sjmhb7j7.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> 
> > From: Ilan Elias <ilane@ti.com>
> >
> > Signed-off-by: Ilan Elias <ilane@ti.com>
> > ---
> >  include/net/nfc/nci.h      |  208 
> ++++++++++++++++++++++---------------------
> >  include/net/nfc/nci_core.h |   13 +--
> >  net/nfc/nci/core.c         |   17 ++--
> >  net/nfc/nci/data.c         |    5 +-
> >  net/nfc/nci/lib.c          |    8 +--
> >  net/nfc/nci/ntf.c          |  152 +++++++++++++++++++-------------
> >  net/nfc/nci/rsp.c          |  149 ++++++++++++++-----------------
> >  7 files changed, 281 insertions(+), 271 deletions(-)
> 
> That's quite a big patch having no commit log. You could at least
> summarise what has been changed and impact of the changes.
> 
> -- 
> Kalle Valo
> 

Sure, you're right.
I'll send out version 2.

Thanks & BR,
Ilan