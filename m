Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:16869 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbYEMK7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 06:59:00 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2112748fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 03:58:58 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: BUG: scheduling while atomic: rt73usb
Date: Tue, 13 May 2008 13:10:19 +0200
Cc: Christian =?iso-8859-15?q?Sch=E4fer?= <schaefer@in.tum.de>,
	linux-wireless@vger.kernel.org
References: <482952C3.9020209@in.tum.de> <1210669171.3646.49.camel@johannes.berg>
In-Reply-To: <1210669171.3646.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805131310.19980.IvDoorn@gmail.com> (sfid-20080513_125905_009285_28992713)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 May 2008, Johannes Berg wrote:
> 
> >   [<f929715a>] rt2x00lib_config_erp+0x7a/0xb0 [rt2x00lib]
> >   [<f929623c>] rt2x00lib_intf_scheduled_iter+0x9c/0xf0 [rt2x00lib]
> >   [<f9309841>] ieee80211_iterate_active_interfaces+0x71/0xa0 [mac80211]
> 
> If I read this correctly, it was recently fixed (but not committed yet
> afaict)

Yes, the fix was send as part of a pull request from rt2x00.git,
and I've requested it to be merged for 2.6.26 as well.

Ivo
