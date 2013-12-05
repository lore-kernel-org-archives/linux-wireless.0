Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52489 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab3LEPnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 10:43:46 -0500
Message-ID: <1386258223.4182.9.camel@jlt4.sipsolutions.net> (sfid-20131205_164350_017579_D7416BB7)
Subject: Re: [PATCH v2] iw: add VHT MCS/NSS set support to set bitrates
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Thu, 05 Dec 2013 16:43:43 +0100
In-Reply-To: <1386234137-3531-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131205_100231_746591_EE306996)
References: <1386234137-3531-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1386234137-3531-4-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131205_100231_746591_EE306996)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 10:02 +0100, Janusz Dziedzic wrote:
> mcs-2.4/mcs-5 rename to ht-mcs-2.4/ht-mcs-5
> vht-mcs-2.4/vht-mcs-5 added
> 
> Format for vht-mcs-*, eg:
> 1  - MCS=1, NSS=1
> 9  - MCS=9, NSS=1
> 10 - MCS=0, NSS=2
> 19 - MCS=9, NSS=2
> 20 - MCS=0, NSS=3
> 29 - MCS=9, NSS=3

I totally don't like that format, can't we parse something like

1:0-9 2:0-7 3:2,4,6

or so?

johannes

