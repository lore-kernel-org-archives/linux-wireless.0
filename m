Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.191]:43583 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYFCTyd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 15:54:33 -0400
Received: by gv-out-0910.google.com with SMTP id e6so317341gvc.37
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 12:54:32 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 02/11] rt2x00: Fix compile-time ffs calculation macros.
Date: Tue, 3 Jun 2008 22:02:03 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032029.40085.IvDoorn@gmail.com> <1212519160.27643.33.camel@johannes.berg>
In-Reply-To: <1212519160.27643.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806032202.03916.IvDoorn@gmail.com> (sfid-20080603_215446_835727_74A9F03D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 June 2008, Johannes Berg wrote:
> On Tue, 2008-06-03 at 20:29 +0200, Ivo van Doorn wrote:
> > The compile_ffsx macros were missing a set of parentheses, which resulted in
> > wrong bit offset calculations.
> > 
> > This fixes rt61pci detection failures, whereby the rf chipset wasn't detected
> > properly due to improper bit shifting.
> > 
> > This patch is based on GertJan's report + patch to fix the parentheses problem
> 
> Sounds like you want to merge that with 1/11?

Good point. I'll resend it. :)

Ivo
