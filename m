Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24785 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969AbZFRGO5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 02:14:57 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 23:15:00 -0700
Date: Thu, 18 Jun 2009 11:43:29 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 4/4] ath9k: Nuke struct ath_tx_ratectrl_state
Message-ID: <20090618061329.GC21792@vasanth-laptop>
References: <1245302612-18112-1-git-send-email-vasanth@atheros.com> <1245302612-18112-2-git-send-email-vasanth@atheros.com> <1245302612-18112-3-git-send-email-vasanth@atheros.com> <1245302612-18112-4-git-send-email-vasanth@atheros.com> <43e72e890906172301x2dc2a4abp26e504617a7a1219@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <43e72e890906172301x2dc2a4abp26e504617a7a1219@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 18, 2009 at 11:31:21AM +0530, Luis R. Rodriguez wrote:
> On Wed, Jun 17, 2009 at 10:23 PM, Vasanthakumar
> Thiagarajan<vasanth@atheros.com> wrote:
> > Move its only member (u8 per) to struct ath_rate_priv.
> 
> yay! BTW are these based on top of my rate series?
> 

Yes.

Vasanth
