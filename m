Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:2547 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbXH1PyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 11:54:10 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1507422nfb
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2007 08:54:09 -0700 (PDT)
Message-ID: <46D44521.9000808@gmail.com>
Date: Tue, 28 Aug 2007 17:54:09 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] Net: ath5k, use short preamble for some rates
References: <2109718751164215004@pripojeni.net> <1188238159.7837.50.camel@johannes.berg>
In-Reply-To: <1188238159.7837.50.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg napsal(a):
> On Sat, 2007-08-25 at 03:58 -0400, Jiri Slaby wrote:
>> ath5k, use short preamble for some rates
>>
>> 2, 5.5 and 11 in b/g are now in short preamble mode
> 
> umm, mac80211 needs to be able to choose depending on the network.

Hmm, misleading log comment. It should be 'can now be in SP mode'.

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
