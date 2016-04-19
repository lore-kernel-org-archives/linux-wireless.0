Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49376 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbcDSLCc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 07:02:32 -0400
Message-ID: <1461063747.2766.22.camel@sipsolutions.net> (sfid-20160419_130235_726838_73EE5F60)
Subject: Re: [RFC] mac80211: add extap functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Grzegorz Bajorski <grzegorz.bajorski@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 19 Apr 2016 13:02:27 +0200
In-Reply-To: <CA+BoTQ=Nw_pW3xk_zkRGw=kTXcfin8Py_xo+WMGsdLcgUiNV4Q@mail.gmail.com> (sfid-20160419_122209_567227_77BEBD32)
References: <1455710131-9967-1-git-send-email-grzegorz.bajorski@tieto.com>
	 <56C4A5ED.4060802@openwrt.org>
	 <CA+BoTQnf953+s++Wiug=BgEw2Ahu7cN1fbatmgyWi_6iAg_v2Q@mail.gmail.com>
	 <1461057103.2766.15.camel@sipsolutions.net>
	 <CA+BoTQ=Nw_pW3xk_zkRGw=kTXcfin8Py_xo+WMGsdLcgUiNV4Q@mail.gmail.com>
	 (sfid-20160419_122209_567227_77BEBD32)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> > How much of that could be done with nftables btw?

> I'm not sure if I follow. Do you mean what I've been able to do with
> relayd until now? Without link-local ipv6 routing DHCPv6 is broken
> (could probably addressed with DHCPv6 Relay to a certain degree) and
> RS/RA may not work (if it propagates fe80:: routes). Also apps that
> rely on fe80:: socket binding/addressing will fail.

Ok, so that makes sense I guess - but you were speaking of some packet
mangling etc. and I was wondering if the nftables virtual machine could
actually do something like that.

johannes
