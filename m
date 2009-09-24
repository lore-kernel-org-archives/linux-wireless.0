Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:63359 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZIXJTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 05:19:37 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH]: nl80211: report age of scan results
Date: Thu, 24 Sep 2009 11:19:28 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200909241055.51604.hs4233@mail.mn-solutions.de> <43e72e890909240159x6d733e1bj9c529f6fe77b32f5@mail.gmail.com>
In-Reply-To: <43e72e890909240159x6d733e1bj9c529f6fe77b32f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909241119.28207.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 September 2009 10:59:57 Luis R. Rodriguez wrote:
> Wil want to #define NL80211_BSS_AGE_MS NL80211_BSS_AGE_MS as
> well so userspace apps can ifdef around that feature to know if
> its supported. 

Nice idea.

That could be a different patch. I haven't seen it for anything 
else, e.g. there's no "#define NL80211_BSS_STATUS" anywhere.

"iw" for example has it's own nl80211.h file.

-- 
http://www.holgerschurig.de
