Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44629
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbXLLPiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 10:38:24 -0500
Date: Wed, 12 Dec 2007 07:38:19 -0800 (PST)
Message-Id: <20071212.073819.49869597.davem@davemloft.net> (sfid-20071212_153827_208611_A5BAE5FF)
To: dcbw@redhat.com
Cc: linville@tuxdriver.com, jt@hpl.hp.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] introduce WEXT scan capabilities
From: David Miller <davem@davemloft.net>
In-Reply-To: <1197473107.12484.3.camel@localhost.localdomain>
References: <1197473107.12484.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Wed, 12 Dec 2007 10:25:07 -0500

> Introduce scan capabilities to WEXT so that userspace can do intelligent
> things with scan behavior such as handling hidden SSIDs more gracefully.
> If the driver reports a specific scan capability, the driver must
> respect the options specified in the iw_scan_req structure when handling
> the SIOCSIWSCAN call, unless it's mode or state does not allow it to do
> so, in which case it must return an error.
> 
> This version switches to Dave Kilroy's suggestion of claiming unused
> padding space for the scan_capa field.
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>

Ok, I'm fine with this.
