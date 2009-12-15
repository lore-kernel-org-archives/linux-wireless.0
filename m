Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:64184 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZLOPAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 10:00:20 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for libertas+cfg80211
Date: Tue, 15 Dec 2009 15:58:48 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <20091022133043.185554096@mail.mn-solutions.de> <1256587966.2110.28.camel@localhost.localdomain> <200912151544.00402.hs4233@mail.mn-solutions.de>
In-Reply-To: <200912151544.00402.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912151558.48844.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This means that STA/IBSS and Libertas' MESH cannot be active at 
> the same time.

Oh, just read the old wext.c and I was wrong.

This magic de-auth / ibss leave happens only if the mesh channel 
is different from the current STA/IBSS channel.

-- 
http://www.holgerschurig.de
