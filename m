Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26084 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbYKEWnb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 17:43:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 14:43:31 -0800
Date: Wed, 5 Nov 2008 14:43:29 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets
	using tx close descriptor for 8187B
Message-ID: <20081105224329.GC9028@tesla> (sfid-20081105_234335_297911_F2A9044B)
References: <200811051936.46361.herton@mandriva.com.br> <557861.93619.qm@web23105.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <557861.93619.qm@web23105.mail.ird.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 05, 2008 at 02:05:31PM -0800, Hin-Tak Leung wrote:
> --- On Wed, 5/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> 
> > Don't know about fc10 kernel, but the changes also
> > include mac80211.ko
> 
> Yes, I know the change includes mac802111.ko, that's why I was surprised that mac80211.ko didn't get built with compat-wireless.
> 
> Turned out that fc10 kernels have mac80211 built-in rather than as modules, so there is no way of replacing them with compat-wireless. 

Umm I have an FC10 box and I see a mac80211.ko. But of course, I have an
early release of FC10, its on 2.6.27-0.244.rc2.git1.fc10.x86_64.

Did the new ones really put it built in?

  Luis
