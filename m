Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41914 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2LTQRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 11:17:21 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so1303273wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2012 08:17:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1356017187.10029.18.camel@jlt4.sipsolutions.net>
References: <1356010313-9782-1-git-send-email-sgruszka@redhat.com>
	<1356010313-9782-2-git-send-email-sgruszka@redhat.com>
	<1356010819.10029.15.camel@jlt4.sipsolutions.net>
	<20121220144549.GA10276@redhat.com>
	<1356017187.10029.18.camel@jlt4.sipsolutions.net>
Date: Thu, 20 Dec 2012 08:09:42 -0800
Message-ID: <CAJ-Vmo=ELCZpMDzTTQ=ae39qd9kg0FAxeDa8G0fiwF9qzWSMbg@mail.gmail.com> (sfid-20121220_171725_569353_24C1BEA3)
Subject: Re: [PATCH 2/3] iwl3945: disable 11a support
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, please don't disable 5ghz on legacy NICs.

I still have laptops with intel 3945's in them, which I use on my 11na
HT40 APs (especially for coexistence testing.)



Adrian
