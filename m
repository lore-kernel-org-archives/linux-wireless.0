Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:39009 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYFIHxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 03:53:17 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1723061waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 00:53:16 -0700 (PDT)
Message-ID: <c85cb4470806090053l5b763a23j43bbf0c87f594b0d@mail.gmail.com> (sfid-20080609_095321_375129_40A10A09)
Date: Mon, 9 Jun 2008 10:53:16 +0300
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Backported MQ requirement on 802.11n for older kernels
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	compat-masters@lists.madwifi.org,
	"Johannes Berg" <johannes@sipsolutions.net>,
	tomas.winkler@intel.com, "Tim Gardner" <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> I just finished trying to backport CONFIG_NETDEVICES_MULTIQUEUE
> requirement for 802.11n to older kernels by relying on the old
> internal mac80211 hacked up MQ support. I've tested the build on
> 2.6.22, 2.6.23, and 2.6.24. Let me know if you get to test this,
> particularly iwl4965 using 11n on 2.6.22.
>

in config.mk you put MAC80211_QOS=m, and i guess that the intention was to put
CONFIG_MAC80211_QOS=m
if this is the case then the compilation fails

Ron
