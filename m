Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:39375 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZBVU1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 15:27:41 -0500
Message-ID: <49A1B538.7090107@gmail.com> (sfid-20090222_212753_590228_B0A68121)
Date: Sun, 22 Feb 2009 21:27:36 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <20090222171032.GD6003@nowhere> <49A1A72A.50102@gmail.com> <20090222194236.GA6060@nowhere> <20090222201821.GA21375@silver.sucs.org>
In-Reply-To: <20090222201821.GA21375@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22.2.2009 21:18, Sitsofe Wheeler wrote:
> This case is more
> coarse as it only deals with allocation rather than initialisation (and
> if you scribble the same value as the poison pattern you go undetected)

This is false negative, yes.

> but I believe this is what Jiri is referring to as a "no false positive
> possibility" case - it's never right to write to unallocated memory.

Exactly, thanks.
