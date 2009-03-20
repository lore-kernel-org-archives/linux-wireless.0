Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:31520 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZCTBFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 21:05:40 -0400
Received: by wf-out-1314.google.com with SMTP id 29so938111wff.4
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 18:05:38 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 Mar 2009 18:05:38 -0700
Message-ID: <43e72e890903191805x19344034w2bb8be34a9000a89@mail.gmail.com> (sfid-20090320_020544_730582_651B32A4)
Subject: nl80211 data prior to nested attributes funky
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	pat-lkml <pat-lkml@erley.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you try to rename a wiphy multiple times with iw you will get
something like this:

wiphy rename: phy #1 to 2
wiphy rename: phy #1 to 3

This just shows an example of an issue I am seeing with another
multicast message I'm working on. I thought it was my code but I've
asked Pat to test and he also saw it. I'd dig more but I have am going
to work on fixing the cfg80211 reg oops with "EU" now.

  Luis
