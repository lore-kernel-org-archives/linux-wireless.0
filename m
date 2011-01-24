Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3379 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab1AXWXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 17:23:12 -0500
Date: Mon, 24 Jan 2011 14:23:04 -0800
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Jamie Kitson" <jamie@kitten-x.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>, rvossen@broadcom.com
Subject: Re: Kernel Panic wlc_mac80211.c Line 6093
Message-ID: <20110124222304.GN2603@broadcom.com>
References: <AANLkTikam0zcxe00UCT4BDQMmrJcPKf1Hbt6=PBokpga@mail.gmail.com>
 <4D3B0390.5070108@broadcom.com>
 <AANLkTinwPrar6ZBhSALBif8__4mHHsKuDYKsgr4FDqtu@mail.gmail.com>
 <op.vptd4dqs3ri7v4@arend-laptop>
 <AANLkTimk3qY87mP5oROnsVOGaPDV2-UAm7UrXST+1mms@mail.gmail.com>
 <op.vpte6up33ri7v4@arend-laptop>
 <AANLkTikB9=xKS0jX7Rz9qLOctaY+Rxv-9HH3p=Ydza85@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <AANLkTikB9=xKS0jX7Rz9qLOctaY+Rxv-9HH3p=Ydza85@mail.gmail.com>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 01:47:37PM -0800, Jamie Kitson wrote:
> > too quote a gremlin: feed me (with any debug experiences you may have).
> 
> Well for some reason when I got home today my machine crashed every
> time it was bringing the wireless interface up until I disabled the
> brcm80211 module, even without the noapic option. The crash looks a
> little different:
> 
> http://farm6.static.flickr.com/5216/5385766744_632eb67670_b.jpg
> 
> Did you notice that someone on that Arch thread suggested that it
> might be solved by using n mode only on the wireless router?
> 
> https://bbs.archlinux.org/viewtopic.php?pid=882237#p882237

Thanks, a little more data to work with.

Roland has a lead on a locking issue that will hopefully resolve the MP
crashes.  However, it does look like there are a couple different issues, and
testing mixed vs. 11n-only networks may shed some more light on the other
issue.

- Henry


