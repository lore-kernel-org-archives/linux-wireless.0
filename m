Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:27024 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbZJZHzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 03:55:48 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for libertas+cfg80211
Date: Mon, 26 Oct 2009 08:55:19 +0100
Cc: linux-wireless@vger.kernel.org
References: <20091022133043.185554096@mail.mn-solutions.de> <1256315335.2164.44.camel@localhost.localdomain> <1256315496.2164.47.camel@localhost.localdomain>
In-Reply-To: <1256315496.2164.47.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910260855.19964.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Which should allow us to use cfg80211 by default, and then have
> only the LIBERTAS_MESH Kconfig option depend on WEXT.  Maybe?

That would be a good idea. I always thought about a LIBERTAS_MESH 
Kconfig right after persistcfg.c was added :-)

-- 
http://www.holgerschurig.de
