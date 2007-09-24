Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:12373 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbXIXTEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 15:04:24 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1462565nfb
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2007 12:04:22 -0700 (PDT)
Message-ID: <46F80A33.2080201@gmail.com>
Date: Mon, 24 Sep 2007 21:04:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mcgrof@gmail.com
Subject: Re: [PATCH 1/3] Net: ath5k, make its own directory
References: <2595810412809010611@pripojeni.net> <1190660419.18521.278.camel@johannes.berg>
In-Reply-To: <1190660419.18521.278.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2007 09:00 PM, Johannes Berg wrote:
> On Mon, 2007-09-24 at 14:39 -0400, Jiri Slaby wrote:
>> ath5k, make its own directory
> 
>> rename from drivers/net/wireless/ath5k_regdom.c
>> rename to drivers/net/wireless/ath5k/ath5k_regdom.c
> 
> imho you should get rid of the ath5k_ prefixes now.

It's OK to me, but this is how bcm, prism and zd do it :). If nobody minds, I
will get rid of the prefix.
