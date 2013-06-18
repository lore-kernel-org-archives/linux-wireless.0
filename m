Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab3FRPWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:22:00 -0400
Message-ID: <1371568907.8318.45.camel@jlt4.sipsolutions.net> (sfid-20130618_172205_686147_CFD3C113)
Subject: Re: [PATCHv2 2/5] nl80211/cfg80211: add channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Tue, 18 Jun 2013 17:21:47 +0200
In-Reply-To: <20130618151424.GA27492@pandem0nium>
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1371212124-26264-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1371566890.8318.32.camel@jlt4.sipsolutions.net>
	 <20130618151424.GA27492@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > If you're going to use nested IEs, shouldn't you define a separate
> > namespace to be used within the nesting?
> 
> The idea was to recycle the nl80211_parse_beacon() function for the CSA IEs,
> but if you prefer I can define an own namespace and create a separate function
> to check.

Hmm, ok. Not sure. This just seems like an awful lot of stack space,
increasing with each new attribute ...

johannes

