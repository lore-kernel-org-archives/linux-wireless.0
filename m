Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:48834 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbZJaKdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 06:33:14 -0400
Received: by ewy28 with SMTP id 28so3666129ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 03:33:18 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ieee80211_tx_status: headroom too small
Date: Sat, 31 Oct 2009 11:33:15 +0100
Cc: Nikolai ZHUBR <zhubr@mail.ru>, linux-wireless@vger.kernel.org
References: <1094614475.20091030230028@mail.ru> <200910311117.22300.IvDoorn@gmail.com> <1256984615.3555.122.camel@johannes.local>
In-Reply-To: <1256984615.3555.122.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910311133.15303.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 October 2009, Johannes Berg wrote:
> On Sat, 2009-10-31 at 11:17 +0100, Ivo van Doorn wrote:
> 
> > At the least the beacons, but I am not sure about if there are other frame types
> > which also have this requirement.
> 
> So you align them all right now? Just wondering since beacons shouldn't
> be status-reported.

Currently I do all, but that is because I am not sure which specific frames
require it. I might just fix this for beacons only and just see what happens
with the other frames.

Ivo
