Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54824 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab2K0Myk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 07:54:40 -0500
Message-ID: <1354020840.950.89.camel@cumari.coelho.fi> (sfid-20121127_135443_574499_7991E80B)
Subject: Re: [PATCH 09/20] wlcore: fwlog dynamic mem_block control
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Ido Reis <idor@ti.com>
Date: Tue, 27 Nov 2012 14:54:00 +0200
In-Reply-To: <1353998701-18171-10-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
	 <1353998701-18171-10-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 08:44 +0200, Arik Nemtsov wrote:
> From: Ido Reis <idor@ti.com>
> 
> number of fwlog mem_blocks can be configured using module param.
> this is a fw debug feature: in case a large fw log data is busrted during
> a short period of time, the memory get filled and data is lost.
> this allows us to dynamicly set the fw log mem_block usage, although
> configuring more mem_block for logger comes at the expense of TP.
> 
> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
> Signed-off-by: Ido Reis <idor@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Who's the original author of this patch? Yair's sob is above Ido's, so
apparently he was the one who created it.  But the From says the author
is Ido...

--
Luca.

