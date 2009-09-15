Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:2304 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbZIOGWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 02:22:36 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: don't report SME connection errs at SIOCSIW{FREQ/AP/ESSID}
Date: Tue, 15 Sep 2009 08:21:57 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
References: <200909141254.14988.hs4233@mail.mn-solutions.de> <200909141323.44245.hs4233@mail.mn-solutions.de> <1252950234.23427.51.camel@johannes.local>
In-Reply-To: <1252950234.23427.51.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909150821.57216.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> And doesn't look correct to me at all. probably something
> missing wrt. disconnect() while connecting.

Can you then outline the right solution ?

-- 
http://www.holgerschurig.de
