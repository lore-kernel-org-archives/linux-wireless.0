Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34398 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909Ab0BPTDx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 14:03:53 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 11:03:53 -0800
Date: Tue, 16 Feb 2010 11:03:50 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH 1/3] compat-wireless-stable-2.6.33.y: Activate ssb
Message-ID: <20100216190350.GL16606@tux>
References: <1265063133-29682-1-git-send-email-y>
 <4B786B9A.3050600@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4B786B9A.3050600@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 14, 2010 at 01:31:06PM -0800, Hauke Mehrtens wrote:
> y@hauke-m.de wrote:
> > From: Hauke Mehrtens <hauke@hauke-m.de>
> > 
> > This is a backport of compat-wireless commit 67228098e77852a0cf50c7c6c413fa601bd6f5b1
> > 
> > Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> > ---
> >  Makefile                          |    4 +---
> >  patches/99-change-makefiles.patch |    6 +++---
> >  scripts/admin-update.sh           |    2 +-
> >  3 files changed, 5 insertions(+), 7 deletions(-)
> > 
> Hi Luis,
> 
> why haven't you appaied these patches to compat-wireless-stable?

I thought I did, sorry, will check again.

> I did something wrong in "git send" so these mails are containing a
> wrong From filed. Should I resend them?


Um, let me check I thought I had applied them, maybe I just had
applied them to the bleeding edge and forgot to propagate to
stable.

  Luis
