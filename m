Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:56485 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066Ab0IOCzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 22:55:49 -0400
Date: Tue, 14 Sep 2010 16:54:47 -1000
From: Jouni Malinen <j@w1.fi>
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@venema.h4ckr.net, me@bobcopeland.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH 3/8] ath5k: Use common ath key management
 functions
Message-ID: <20100915025447.GA30253@jm.kir.nu>
References: <20100908070427.11255.17659.stgit@tt-desk>
 <20100908070443.11255.13951.stgit@tt-desk>
 <20100911172250.GE20385@hash.localnet>
 <201009131009.59765.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201009131009.59765.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 13, 2010 at 10:09:59AM +0900, Bruno Randolf wrote:
> i don't know wether we can encrypt management frames in HW, so until this is 
> sorted out, i disabled it.

I don't think any of the hardware supported by ath5k would be able to do
this. IEEE 802.11w design changes in CCMP for management frames are more
recent than the hardware designs supported by ath5k..
 
-- 
Jouni Malinen                                            PGP id EFC895FA
