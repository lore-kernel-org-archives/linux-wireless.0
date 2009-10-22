Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:42967 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZJVH25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 03:28:57 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: remove unused lbs_cmd_802_11_inactivity_timeout()
Date: Thu, 22 Oct 2009 09:28:34 +0200
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <200910161734.22840.hs4233@mail.mn-solutions.de> <200910190854.19967.hs4233@mail.mn-solutions.de> <1256148756.5010.34.camel@localhost.localdomain>
In-Reply-To: <1256148756.5010.34.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910220928.34333.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Pretty much like it sounds; it lets the device go to into
> powersave at user-specified interval after the last TX or RX,
> instead of having to wait one full beacon of inactivity.

Ok, nice.

But it could also have sounded like "report how long the card was 
inactive", e.g. what "iw XXX link" can show.



Do you already have any idea about how to make those things like 
TCP, inactivity etc available in NL80211/cfg80211 ?


-- 
http://www.holgerschurig.de
