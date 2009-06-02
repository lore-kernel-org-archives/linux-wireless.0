Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36936 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZFBQna (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 12:43:30 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 09:43:32 -0700
Date: Tue, 2 Jun 2009 09:43:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k: Remove modparam 'debug'
Message-ID: <20090602164338.GA6906@tesla>
References: <1243951136-4033-1-git-send-email-vasanth@atheros.com> <1243951136-4033-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1243951136-4033-2-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 02, 2009 at 06:58:56AM -0700, Vasanth Thiagarajan wrote:
> -         modprobe ath9k debug=0x00002000
> +         echo <debug mask> > /<debugfsroot>/ath9k/phyX/debug

This means no debugging available during module init which does seem
useful to keep.

  Luis
