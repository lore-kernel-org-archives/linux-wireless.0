Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:9945 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZJPMQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 08:16:58 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [WIP, RFC] libertas: allow scanning via "iw"
Date: Fri, 16 Oct 2009 14:15:02 +0200
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
References: <200910141652.11203.hs4233@mail.mn-solutions.de> <1255686611.4095.323.camel@johannes.local>
In-Reply-To: <1255686611.4095.323.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910161415.02899.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It'd be easier to read and see what the patch does if you
> actually removed all the stuff that is no longer necessary :)

Sure, you can easily get a patch that removes all the cruft that 
don't need so far.

As I managed to get a connection via WEP, WEP104, WPA, WPA2 
NO-ENCRYPTION to an AP today (including pings via the link), 
I'll send a new WIP/RFC anyway.

-- 
http://www.holgerschurig.de
