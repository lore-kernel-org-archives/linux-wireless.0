Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:64342 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759233AbYAJRZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 12:25:09 -0500
Received: by fk-out-0910.google.com with SMTP id z23so541292fkz.5
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 09:25:07 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: proper short-slot handling
Date: Thu, 10 Jan 2008 18:25:01 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <br1@einfach.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Yanbo Li <dreamfly281@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Daniel Drake <dsd@gentoo.org>
References: <1199974496.3861.80.camel@johannes.berg>
In-Reply-To: <1199974496.3861.80.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801101825.02354.IvDoorn@gmail.com> (sfid-20080110_172526_247065_EBE1E97A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 January 2008, Johannes Berg wrote:
> Sorry about the long CC list, I wanted all driver people to be aware.
> 
> I really need help converting drivers, I attempted a few but without
> understanding the hardware it's not easy to pull off. First though, we
> should discuss whether this patch is the right approach. Any comments?
> 
> If you think it is the right approach, maybe try converting your driver
> and see if that results in any problems, if not, send me the patch and
> I'll integrate it.
> 
> If, on the other hand, you think the current mechanism is appropriate,
> we'll have to fix the bugs with it in another way.
> 
> This patch probably depends on my cfg80211 rate API patch thought it
> might apply without it.
> 
> johannes

Sounds good to me, it will actually remove some ugly hacks in rt2x00. :)
I'll prepare a patch for rt2x00.

Ivo
