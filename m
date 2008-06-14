Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:11681 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbYFNVsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2008 17:48:30 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3783703waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2008 14:48:29 -0700 (PDT)
Subject: Re: [PATCH] rt2x00: Use ieee80211 fc handlers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200806142057.10520.IvDoorn@gmail.com>
References: <200806142057.10520.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Sat, 14 Jun 2008 14:48:30 -0700
Message-Id: <1213480110.11544.21.camel@brick> (sfid-20080614_234833_656134_AD5AD682)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-06-14 at 20:57 +0200, Ivo van Doorn wrote:
> With the introduction of the ieee80211 fc handlers
> we can now remove the rt2x00.h versions to use the
> global versions.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

I had a similar patch locally I hadn't sent out yet.  Yours looks fine
from a quick look-through and a run through sparse to check for any
missed endian changes,

Reviewed-by: Harvey Harrison <harvey.harrison@gmail.com>


