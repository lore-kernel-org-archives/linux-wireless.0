Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33072 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbbIWMaf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 08:30:35 -0400
Message-ID: <1443011425.1889.12.camel@sipsolutions.net> (sfid-20150923_143051_908818_213E7AA6)
Subject: Re: [PATCH 1/3] mac80211: Deinline drv_switch_vif_chanctx()
From: Johannes Berg <johannes@sipsolutions.net>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 23 Sep 2015 14:30:25 +0200
In-Reply-To: <1443010716-32651-1-git-send-email-dvlasenk@redhat.com> (sfid-20150923_141933_950247_3C71FF03)
References: <1443010716-32651-1-git-send-email-dvlasenk@redhat.com>
	 (sfid-20150923_141933_950247_3C71FF03)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-23 at 14:18 +0200, Denys Vlasenko wrote:
> With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
> after deinlining the function size is 821 bytes and there are
> 2 callsites, reducing code size by about 800 bytes.
> 
Thanks, all applied.

johannes
