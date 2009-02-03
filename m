Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45348 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbZBCKTS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 05:19:18 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 02:19:18 -0800
Date: Tue, 3 Feb 2009 15:49:11 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: Remove bss information of the current AP
	when it goes out of range
Message-ID: <20090203101911.GC8246@vasanth-laptop> (sfid-20090203_111922_846782_53A7CFEF)
References: <1233635989-20664-1-git-send-email-vasanth@atheros.com> <1233655853.5460.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1233655853.5460.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 03, 2009 at 03:40:53PM +0530, Johannes Berg wrote:
> On Tue, 2009-02-03 at 10:09 +0530, Vasanthakumar Thiagarajan wrote:
> > There is no point having the bss information of currently associated AP
> > when the AP is detected to be out of range.
> 
> Seems sane to me. There are a few other places I think where we hold on
> to the bss info way too long, in fact, we hold on to it _forever_ most
> of the time.
> 

Yeah, we hold bss info when we get direct probe timeout, auth timeout and assoc
timeout. I will remove bss in those places also n the next version.

Thanks,

Vasanth
