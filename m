Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48941 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbcDSJLs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 05:11:48 -0400
Message-ID: <1461057103.2766.15.camel@sipsolutions.net> (sfid-20160419_111153_068546_EE3B67AF)
Subject: Re: [RFC] mac80211: add extap functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	Felix Fietkau <nbd@openwrt.org>
Cc: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 19 Apr 2016 11:11:43 +0200
In-Reply-To: <CA+BoTQnf953+s++Wiug=BgEw2Ahu7cN1fbatmgyWi_6iAg_v2Q@mail.gmail.com> (sfid-20160418_132353_986196_638EA8F9)
References: <1455710131-9967-1-git-send-email-grzegorz.bajorski@tieto.com>
	 <56C4A5ED.4060802@openwrt.org>
	 <CA+BoTQnf953+s++Wiug=BgEw2Ahu7cN1fbatmgyWi_6iAg_v2Q@mail.gmail.com>
	 (sfid-20160418_132353_986196_638EA8F9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-04-18 at 13:23 +0200, Michal Kazior wrote:

> You can't really implement complete IPv6 support in relayd though.
> Link-local routing is forbidden by the spec explicitly and a patch
> I've cooked up was rejected[1].
> 
> I guess this leaves either the kernel's wireless stack to take up the
> task or a special link device (for which I'm soliciting feedback now
> [2]).
> 

I think you'll probably have to cook up a simple patch to get that
question in [2] taken seriously :)

How much of that could be done with nftables btw?

johannes
