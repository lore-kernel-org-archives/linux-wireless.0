Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43913 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbZFCE6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 00:58:32 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 21:58:35 -0700
Date: Wed, 3 Jun 2009 10:27:17 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k: Remove modparam 'debug'
Message-ID: <20090603045717.GD17632@vasanth-laptop>
References: <1243951136-4033-1-git-send-email-vasanth@atheros.com> <1243951136-4033-2-git-send-email-vasanth@atheros.com> <20090602164338.GA6906@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090602164338.GA6906@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 02, 2009 at 10:13:38PM +0530, Luis Rodriguez wrote:
> On Tue, Jun 02, 2009 at 06:58:56AM -0700, Vasanth Thiagarajan wrote:
> > -         modprobe ath9k debug=0x00002000
> > +         echo <debug mask> > /<debugfsroot>/ath9k/phyX/debug
> 
> This means no debugging available during module init which does seem
> useful to keep.

Thats true,let's keep it, thanks.

Vasanth
