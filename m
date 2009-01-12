Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10622 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZALGy7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 01:54:59 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2009 22:54:59 -0800
Date: Mon, 12 Jan 2009 12:24:38 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Kalle Valo <kalle.valo@iki.fi>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k: Fix basic connectivity issue
Message-ID: <20090112065438.GA2008@vasanth-laptop> (sfid-20090112_075503_670730_D04C0FE5)
References: <1231587429-23989-1-git-send-email-vasanth@atheros.com> <87sknrjrgk.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87sknrjrgk.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +static int btcoex_enable;
> > +module_param(btcoex_enable, bool, 0);
> > +MODULE_PARM_DESC(btcoex_enable, "Enable Bluetooth coexistence support");
> 
> Somehow I guessed that this was coming :) I still think that a proper
> nl80211 interface for this is in order.

I agree that there should be a proper nl80211 interface for BT coex
configuration. It is just an interim solution for the regression.

Vasanth
