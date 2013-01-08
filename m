Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:41353 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab3AHC4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 21:56:38 -0500
Message-ID: <50EB8B1A.9000404@asianux.com> (sfid-20130108_035716_929288_6E02057F)
Date: Tue, 08 Jan 2013 10:57:30 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	stas.yakovlev@gmail.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [RFC PATCH] vsprintf: Add %p*D extension for 80211 SSIDs
References: <50E82D7D.4090107@asianux.com>  <1357396966.21156.4.camel@joe-AO722> <50EA37CE.1090901@asianux.com>  <1357528746.4940.31.camel@joe-AO722> <1357534195.21481.31.camel@joe-AO722>  (sfid-20130107_055017_668200_9F1C3EAF) <1357544828.9912.0.camel@jlt4.sipsolutions.net> <1357579362.21481.45.camel@joe-AO722>
In-Reply-To: <1357579362.21481.45.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

于 2013年01月08日 01:22, Joe Perches 写道:
> On Mon, 2013-01-07 at 08:47 +0100, Johannes Berg wrote:
>> > print_ssid() is used in two or
>> > three legacy drivers only, not in any modern driver, and is unlikely to
>> > be used in the more modern drivers due to tracing etc.
> Swell.  It was just another way to correct those overrun
> errors Chen Gang found.
> 

  sorry, I am not quite clear about what you said.


-- 
Chen Gang

Asianux Corporation
