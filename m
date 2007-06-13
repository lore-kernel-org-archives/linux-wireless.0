Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39508 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbXFMUbM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 16:31:12 -0400
Message-ID: <467053F2.8080009@garzik.org>
Date: Wed, 13 Jun 2007 16:30:42 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: MSI support
References: <20070613112939.3b73f928@localhost>	<467039E0.7080109@garzik.org> <20070613132823.2903bf5f@localhost>
In-Reply-To: <20070613132823.2903bf5f@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Hemminger wrote:
> Add Message Signal Interrupt support to iwlwifi. Tested on 3945.
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

looks good to me, though I will let our illustrious wireless maintainer 
merge it and push it upstream :)


