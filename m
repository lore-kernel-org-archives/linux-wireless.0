Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14355 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab0LAIhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 03:37:00 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 00:36:46 -0800
Date: Wed, 1 Dec 2010 14:06:42 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/26] Add support for AR9485
Message-ID: <20101201083641.GH12908@vasanth-laptop>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com> <AANLkTi=9y+BfLGxSqofYkeMZEXA8QDrsaPG0yLtYNEi2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTi=9y+BfLGxSqofYkeMZEXA8QDrsaPG0yLtYNEi2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 01, 2010 at 01:22:12PM +0530, Luis R. Rodriguez wrote:
> On Tue, Nov 30, 2010 at 11:32 PM, Vasanthakumar Thiagarajan
> <vasanth@atheros.com> wrote:
> > John,
> >
> >        This patch series add support for a new chipset of AR9003 family.
> > This chip(AR9485) is an 1x1 and 2.4Ghz band only.
> 
> Very nice Vasanth, good stuff! If these are all checkpatch.pl and sparse tested:

Yes, sparse and checkpatch.pl tested, got some checkpatch.pl
warnings for being over 80 char, but that should be fine.
Thanks for the review.

Vasanth
