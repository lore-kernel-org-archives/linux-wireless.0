Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:30950 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbYGHMnP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 08:43:15 -0400
Received: from zps38.corp.google.com (zps38.corp.google.com [172.25.146.38])
	by smtp-out.google.com with ESMTP id m68ChB1q031059
	for <linux-wireless@vger.kernel.org>; Tue, 8 Jul 2008 13:43:11 +0100
Received: from wf-out-1314.google.com (wfc28.prod.google.com [10.142.3.28])
	by zps38.corp.google.com with ESMTP id m68Ch41T001723
	for <linux-wireless@vger.kernel.org>; Tue, 8 Jul 2008 05:43:10 -0700
Received: by wf-out-1314.google.com with SMTP id 28so2829224wfc.20
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 05:43:10 -0700 (PDT)
Message-ID: <f4845fc0807080543g121f0222yf4591dd8eb1a5478@mail.gmail.com> (sfid-20080708_144320_671501_EEAD5CF9)
Date: Tue, 8 Jul 2008 14:43:09 +0200
From: "Julius Volz" <juliusv@google.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] net/wireless/nl80211.c: fix endless Netlink callback loop.
Cc: netdev@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1215520235.9610.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215518539-19587-1-git-send-email-juliusv@google.com>
	 <1215518799.9610.33.camel@johannes.berg>
	 <f4845fc0807080523o7e773de2u94c10a8739f4ddf4@mail.gmail.com>
	 <1215520235.9610.39.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 8, 2008, Johannes Berg wrote:
> Not sure. I guess the code isn't touched often so your patch is fine.

Ok, thanks!

The other dump functions in that file look like they might have the
same problem, but they are a bit more involved.

Julius

-- 
Google Switzerland GmbH
