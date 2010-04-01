Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45296 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab0DAQH6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 12:07:58 -0400
Subject: Re: [PATCH 1/3] ath: Add a bus type field
From: Pavel Roskin <proski@gnu.org>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <19380.10220.955466.246781@gargle.gargle.HOWL>
References: <19380.10220.955466.246781@gargle.gargle.HOWL>
Content-Type: text/plain
Date: Thu, 01 Apr 2010 12:07:55 -0400
Message-Id: <1270138075.4608.31.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-01 at 10:28 +0530, Sujith wrote:
> This can be used to store the bus types ( AHB/PCI/USB ).
 
> +enum ath_bus_type {
> +	ATH_PCI,
> +	ATH_AHB,
> +	ATH_USB,
> +};

I like the idea, but let's have ATH_BUS_PCI, ATH_BUS_AHB and
ATH_BUS_USB.  This way, one would be able to grep for "ATH_BUS_" to find
all occurrences of those symbols.

There are already symbols starting with "ATH_PCI", such as
ATH_PCIE_CAP_LINK_CTRL.

-- 
Regards,
Pavel Roskin
