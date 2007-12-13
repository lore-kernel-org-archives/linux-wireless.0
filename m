Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:28085 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbXLMNnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 08:43:46 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1090078wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2007 05:43:44 -0800 (PST)
Message-ID: <1ba2fa240712130543q703137d4o8b895247e4cc914a@mail.gmail.com> (sfid-20071213_134349_566042_64F9B2FA)
Date: Thu, 13 Dec 2007 15:43:44 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 ethtool support
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Michael Buesch" <mb@bu3sch.de>, "Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197545930.6558.243.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197361048.3170.381.camel@debian.sh.intel.com>
	 <200712111350.25522.mb@bu3sch.de>
	 <1197421988.3170.405.camel@debian.sh.intel.com>
	 <200712121148.48716.mb@bu3sch.de>
	 <1197481520.6558.140.camel@johannes.berg>
	 <1ba2fa240712121523h59d919f8k42fe54b992618432@mail.gmail.com>
	 <20071213002739.GB3139@tuxdriver.com>
	 <1197545930.6558.243.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 13, 2007 1:38 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > Has anyone taken the trouble to analyze the various ethtool operations
> > to see which ones even make sense for wireless devices?  That might
> > make a better starting point for discussing how to implement whatever
> > remains.
>
> Most, except very few hardware-specific like the EEPROM under discussion
> and a few driver-specific (get driver version etc) don't make any sense,
> like WOL, GSO, pause, UFO, ...

I've checked that too and I agree it looks like we need ethool brother
for wireless some wifitool.  But it looks like
cfg80211 can provide this functionality

BTW iwl HW supports WOL  :)

> johannes
>
