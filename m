Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47889
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753942AbYIVWro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 18:47:44 -0400
Date: Mon, 22 Sep 2008 15:47:32 -0700 (PDT)
Message-Id: <20080922.154732.189681566.davem@davemloft.net> (sfid-20080923_004753_527125_F6B74058)
To: akpm@linux-foundation.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	born.into.silence@gmail.com, dsd@gentoo.org,
	johannes@sipsolutions.net, kune@deine-taler.de
Subject: Re: [patch 1/1] wireless: zd1211rw: add device ID fix wifi dongle
 "trust nw-3100"
From: David Miller <davem@davemloft.net>
In-Reply-To: <200809222201.m8MM1pBH032706@imap1.linux-foundation.org>
References: <200809222201.m8MM1pBH032706@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: akpm@linux-foundation.org
Date: Mon, 22 Sep 2008 15:01:51 -0700

> From: <born.into.silence@gmail.com>
> 
> akpm: taken from http://bugzilla.kernel.org/show_bug.cgi?id=11587
> 
> I bought the wifi dongle trust nw-3100 wich is in fact a zd1211rw.  Its
> hardware id was missing in the sources, adding it made it work flawlessly.
> 
> Cc: Daniel Drake <dsd@gentoo.org>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Ulrich Kunitz <kune@deine-taler.de>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I just got this via a pull request from John Linville so it's in
net-2.6 and on it's way already.
