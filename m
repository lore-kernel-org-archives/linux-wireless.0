Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:45596 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbcFUM3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 08:29:35 -0400
From: "Machani, Yaniv" <yanivma@ti.com>
To: Bob Copeland <me@bobcopeland.com>,
	"Altshul, Maxim" <maxim.altshul@ti.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"eliad@wizery.com" <eliad@wizery.com>, "Mishol, Guy" <guym@ti.com>,
	"arik@wizery.com" <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 0/3] *** Mesh Path Selection Metric Calculation ***
Date: Tue, 21 Jun 2016 12:23:48 +0000
Message-ID: <AE1C82FB3D0EC64DB1F752C81CBD1101391CC2B1@DFRE01.ent.ti.com> (sfid-20160621_142939_561469_21FE6CCB)
References: <1466427622-5953-1-git-send-email-maxim.altshul@ti.com>
 <20160621121905.GA4210@localhost>
In-Reply-To: <20160621121905.GA4210@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes,
TI driver have added support in our latest release (TI git).
http://software-dl.ti.com/ecs/WiLink8/R8_7/exports/release_notes_R8_7.html

Patches will be shared with mainline in the near future.

Thanks,
Yaniv Machani

-----Original Message-----
From: Bob Copeland [mailto:me@bobcopeland.com] 
Sent: Tuesday, June 21, 2016 15:19
To: Altshul, Maxim
Cc: johannes@sipsolutions.net; kvalo@codeaurora.org; eliad@wizery.com; Machani, Yaniv; Mishol, Guy; arik@wizery.com; linux-wireless@vger.kernel.org; netdev@vger.kernel.org; davem@davemloft.net
Subject: Re: [PATCH 0/3] *** Mesh Path Selection Metric Calculation ***

On Mon, Jun 20, 2016 at 04:00:19PM +0300, Maxim Altshul wrote:
> 2. Implements the opcode and the mechanism that reports the rates in 
> TI driver.

Does this mean TI driver will support mesh at some point?

--
Bob Copeland %% http://bobcopeland.com/
