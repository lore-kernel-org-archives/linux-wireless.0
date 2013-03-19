Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49337 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933780Ab3CSWTE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 18:19:04 -0400
Date: Tue, 19 Mar 2013 18:19:01 -0400 (EDT)
Message-Id: <20130319.181901.2168502438004923434.davem@davemloft.net> (sfid-20130319_231916_149734_F461BFBD)
To: julian.calaby@gmail.com
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: Add socket() system call self test.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGRGNgU4nyDrbbN6QWh06PknACP9+h2sFrRcNyOLU_pnwMU5EA@mail.gmail.com>
References: <20130319.145258.1891905092469394685.davem@davemloft.net>
	<CAGRGNgU4nyDrbbN6QWh06PknACP9+h2sFrRcNyOLU_pnwMU5EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 20 Mar 2013 09:12:09 +1100

> Should that not be "vmtests"?

Fixed already:

http://patchwork.ozlabs.org/patch/229221/
