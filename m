Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37960 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYLQQAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 11:00:21 -0500
Date: Wed, 17 Dec 2008 10:55:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <bcopeland@gmail.com>
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>,
	Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: Updated padding stuff for the RX and TX side.
	TX side has been 100%
Message-ID: <20081217155533.GB12679@tuxdriver.com> (sfid-20081217_170026_870988_1C5B69A7)
References: <1229351698-21116-1-git-send-email-benoit.papillault@free.fr> <20081215170613.GA22627@jm.kir.nu> <4946C6D9.1060101@free.fr> <b6c5339f0812160722nab8516cj1ed4e6d397060d9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f0812160722nab8516cj1ed4e6d397060d9d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 16, 2008 at 10:22:39AM -0500, Bob Copeland wrote:
> On Mon, Dec 15, 2008 at 4:06 PM, Benoit PAPILLAULT
> <benoit.papillault@free.fr> wrote:
> 
> > frames. To me, the bug we have seen when receiving a ACK frame in
> > monitor mode was not because "ACK is a small control frame", it was
> > because the header length we computed was smaller than what the hardware
> > considered.
> 
> It's because data frames have a payload and ACKs do not.
> 
> > To reply to Bob as well, we need to compute the number of padded bytes +
> > the position at which the padding occurs, so proper "header" length is
> > required.
> 
> Well, anyway John already picked up your earlier (better, IMHO) patch.
> Now we just need to fix the tx descriptors :)

Based on that comment, I'm dropping this version of the patch.
Feel free to submit additional patches to implement whatever might
be missing now.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
