Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:2338 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZIXKJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 06:09:14 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH]: nl80211: report age of scan results
Date: Thu, 24 Sep 2009 12:09:05 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <200909241055.51604.hs4233@mail.mn-solutions.de> <1253786034.3868.18.camel@johannes.local>
In-Reply-To: <1253786034.3868.18.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909241209.05377.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm not sure "age" is appropriate -- the BSS entry might be older but
> have been touched in a new scan etc.
> 
> Maybe "last seen"? Although that kinda implies an absolute time while
> "age" implies a relative time ... hmm ...

NL80211_BSS_SEEN_MS_AGO ?

-- 
http://www.holgerschurig.de
