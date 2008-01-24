Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.241]:58546 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752279AbYAXPRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 10:17:46 -0500
Received: by hs-out-2122.google.com with SMTP id 54so253659hsz.5
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2008 07:17:45 -0800 (PST)
Message-ID: <1ba2fa240801240717y35ed36bdjd5399f00dd73d687@mail.gmail.com> (sfid-20080124_151759_171065_0DEA6FD4)
Date: Thu, 24 Jan 2008 17:17:43 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: proper short-slot handling
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"bruno randolf" <br1@einfach.org>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Yanbo Li" <dreamfly281@gmail.com>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	"Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <1201163934.3454.42.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1199974496.3861.80.camel@johannes.berg>
	 <200801161737.00682.IvDoorn@gmail.com>
	 <1200501699.8708.9.camel@johannes.berg>
	 <200801161751.58244.IvDoorn@gmail.com>
	 <1ba2fa240801221226ra00fd76x8724b51023717b5e@mail.gmail.com>
	 <1201163934.3454.42.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 24, 2008 10:38 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > Finally I got to test this but somehow I'm not getting any changed bit
> > set except
> > association one. I'm still not sure if this is problem of iwl driver or mac80211
> > If anybody tested please let me know
>
> Hmm. And you're positive the network you were on supports short slot?
> But looking closely at the code does reveal a bug, short slot should be
> supported even in absence of an ERP IE.
>
This should be present in capability IE which is always present

> johannes
>
