Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39651 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbYIHFEu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 01:04:50 -0400
Date: Mon, 8 Sep 2008 10:29:26 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] Ath9k: Add RF kill support.
Message-ID: <20080908045926.GA28149@vasanth-lnx.users.atheros.com> (sfid-20080908_070455_281072_F037D78F)
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com> <1220721347.6714.114.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1220721347.6714.114.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 06, 2008 at 10:45:47PM +0530, Marcel Holtmann wrote:
> Hi Vasanthakumar,
> 
> > CONFIG_ATH9K_RFKILL needs to be set
> > to enable this support.
> 
> why do we have to introduce yet another config option for this? What is
> the advantage of disabling RFKILL support? I really don't see it and all
> these extra config options are rather confusing than useful.
Normally home users may not hit a situation where they have to
disable the radio, so they can compile out the rf kill support
and essentially disable the periodic run of the work queue 
(rfkill_poll ,runs for every 2 secs).If this does not make 
any sense, I will remove this config option.
> 
> Regards
> 
> Marcel
> 
> 
Thanks for your comments.

Regards,
Vasanth
