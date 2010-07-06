Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16579 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab0GFE7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 00:59:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Jul 2010 21:59:53 -0700
Date: Tue, 6 Jul 2010 10:29:45 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "greearb@gmail.com" <greearb@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Subject: Re: [ath9k] ath9k:  Expose virtual wiphy indexes to debugfs.
Message-ID: <20100706045945.GF5053@vasanth-laptop>
References: <1278359545-29013-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1278359545-29013-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 06, 2010 at 01:22:25AM +0530, greearb@gmail.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> It is very difficult to map phyX devices to real/virtual
> entities because the phyX devices change on module
> reload.  This patch makes it slightly easier to
> associate virtual phy devices with phyX entities.
> 

It does not make much sense to give an index while creating a new
virtual wiphy interface. This is unncessary, only wiphy name
matters.

Vasanth
