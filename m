Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:8341 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbXB1QIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 11:08:12 -0500
Received: by nf-out-0910.google.com with SMTP id o25so597740nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 08:08:11 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 14/28] rt2x00: Create rt2x00lib module
Date: Wed, 28 Feb 2007 17:08:07 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.13004.IvDoorn@gmail.com> <200702281657.50102.IvDoorn@gmail.com> <1172678429.5015.27.camel@johannes.berg>
In-Reply-To: <1172678429.5015.27.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281708.07905.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 17:00, Johannes Berg wrote:
> On Wed, 2007-02-28 at 16:57 +0100, Ivo van Doorn wrote:
> 
> > Thanks for the tip. I'll try to fix this.
> > 
> > Both things will end up in a new patch which I will send as soon as I have that
> > debugfs config option fixed. :)
> 
> And another btw. How about using the wiphy debugfs node?

Good point, I had created debugfs before the entire wiphy integration into
wireless-dev and hadn't noticed that entry yet. I'll fix that as soon as possible as well.

Ivo
