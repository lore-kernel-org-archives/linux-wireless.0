Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:14519 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbZIJWTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 18:19:36 -0400
Received: by ey-out-2122.google.com with SMTP id 25so124809eya.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 15:19:38 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: rt2x00: Hardcode TX ack timeout and consume time
Date: Fri, 11 Sep 2009 00:19:35 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
References: <200909061514.23611.IvDoorn@gmail.com> <20090908183648.GE2617@tuxdriver.com>
In-Reply-To: <20090908183648.GE2617@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909110019.35994.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 September 2009, John W. Linville wrote:
> On Sun, Sep 06, 2009 at 03:14:23PM +0200, Ivo van Doorn wrote:
> > rt2x00: Hardcode TX ack timeout and consume time
> 
> > John, this patch has not yet been confirmed by any of the above bugzilla reports,
> > but I do think this should be merged as soon as possible to 2.6.31 since this issue
> > has been marked as regression for quite some time now. :)
> 
> Well, given how late it is in the 2.6.31 cycle and the fact that this
> problem has persisted for a while I think I'll just let this slip to
> 2.6.32 -- good enough?

Well preferably not, but I can sit it out and try to push it into -stable
for 2.6.31.1. That might be the easiest solution which worked the last time
when I had an urgent fix late in the release cycle as well. :)

Ivo
