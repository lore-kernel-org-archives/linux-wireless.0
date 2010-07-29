Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:12244 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755198Ab0G2JO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 05:14:28 -0400
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0936684866
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 18:14:27 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] iw: Add antenna configuration commands
Date: Thu, 29 Jul 2010 18:14:44 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20100727094932.27300.10253.stgit@tt-desk> <201007291235.11202.br1@einfach.org> <1280389745.3823.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1280389745.3823.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007291814.44330.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu July 29 2010 16:49:05 Johannes Berg wrote:
> On Thu, 2010-07-29 at 12:35 +0900, Bruno Randolf wrote:
> > actually - no. what sense does it make to use a hexadecimal notation and
> > print 0x for values between 0 and 7?
> 
> Well ... 11n does define mimo 4x4.

oh, yes, true: 0xf

bruno
