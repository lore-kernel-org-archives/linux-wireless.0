Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37042 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab3DVPv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 11:51:58 -0400
Received: by mail-wg0-f52.google.com with SMTP id k13so1021385wgh.31
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2013 08:51:57 -0700 (PDT)
Date: Mon, 22 Apr 2013 17:51:40 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6 1/3] mac80211: improve the rate control API
Message-ID: <20130422155139.GA28133@gobelin> (sfid-20130422_175202_396423_D095E7B6)
References: <1366640083-1054-1-git-send-email-nbd@openwrt.org>
 <1366640311.8637.25.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366640311.8637.25.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 22, 2013 at 04:18:31PM +0200, Johannes Berg wrote:
> On Mon, 2013-04-22 at 16:14 +0200, Felix Fietkau wrote:
> > Allow rate control modules to pass a rate selection table to mac80211
> > and the driver. This allows drivers to fetch the most recent rate
> > selection from the sta pointer for already buffered frames. This allows
> > rate control to respond faster to sudden link changes and it is also a
> > step towards adding minstrel_ht support to drivers like iwlwifi.
> 
> Applied all. Karl, thanks for the detailed review!
> 
No problem, it's nice to know it was appreciated ;)
 
Karl
