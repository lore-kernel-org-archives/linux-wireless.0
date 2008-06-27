Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serv04.lahn.de ([213.239.197.57]:49743 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762449AbYF0SFL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 14:05:11 -0400
Date: Fri, 27 Jun 2008 20:04:17 +0200
From: linux-wireless@newton.leun.net
To: linux-wireless@vger.kernel.org
Cc: yi.zhu@intel.com
Subject: Re: compat wireless, i3945, tcpdump: Machine freezes
Message-ID: <20080627200417.22d3488b@localhost> (sfid-20080627_200519_723164_1F60245A)
In-Reply-To: <1214442132.14590.282.camel@debian.sh.intel.com>
References: <20080618094213.5abd2fbd@localhost>
 <20080625154354.719cc9b3@localhost>
 <1214442132.14590.282.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Thu, 26 Jun 2008 09:02:12 +0800
Zhu Yi <yi.zhu@intel.com> wrote:

> > > I downloaded compat-wireless-2008-06-18, built it, loaded
> > > cfg80211.ko, mac80211.ko, iwl3945.ko, associated to an ap,
> > > started "tcpdump -i wlan0 -n" and the machine mostly freezed.
> > > 
> > > Mostly means keyboard does not work, no disk-access, no network
> > > but mouse still works.
> > This still happens with compat-wireless-2008-06-25.
> 
> We have a fix patch here. Will submit to linux-wireless after some
> tweak.
> http://article.gmane.org/gmane.linux.drivers.ipw3945.devel/3166

Yup, that works - does not freeze anymore. But when switching
promiscuous on it reassociates and there is a network outage of several
seconds.

Thanks!

-- 
Bye,

Michael Leun

