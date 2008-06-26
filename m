Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1644 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145AbYFZBDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 21:03:12 -0400
Subject: Re: compat wireless, i3945, tcpdump: Machine freezes
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@newton.leun.net
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080625154354.719cc9b3@localhost>
References: <20080618094213.5abd2fbd@localhost>
	 <20080625154354.719cc9b3@localhost>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 09:02:12 +0800
Message-Id: <1214442132.14590.282.camel@debian.sh.intel.com> (sfid-20080626_030321_065370_43106517)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-25 at 15:43 +0200, linux-wireless@newton.leun.net wrote:
> Hello,
> 
> On Wed, 18 Jun 2008 09:42:13 +0200
> Michael Leun <linux-wireless@newton.leun.net> wrote:
> 
> > I downloaded compat-wireless-2008-06-18, built it, loaded cfg80211.ko,
> > mac80211.ko, iwl3945.ko, associated to an ap, started "tcpdump -i
> > wlan0 -n" and the machine mostly freezed.
> > 
> > Mostly means keyboard does not work, no disk-access, no network but
> > mouse still works.
> [...]
> 
> This still happens with compat-wireless-2008-06-25.

We have a fix patch here. Will submit to linux-wireless after some
tweak.
http://article.gmane.org/gmane.linux.drivers.ipw3945.devel/3166

Thanks,
-yi

