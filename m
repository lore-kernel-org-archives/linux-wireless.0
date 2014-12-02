Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:59353 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbaLBVkQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 16:40:16 -0500
Message-ID: <547E31BD.8090302@msgid.tls.msk.ru> (sfid-20141202_224031_042637_0C0AA73E)
Date: Wed, 03 Dec 2014 00:40:13 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Maximilian Engelhardt <maxi@daemonizer.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Subject: Re: BCM4313 & brcmsmac & 3.12: only semi-working?
References: <53FDACD1.8090805@msgid.tls.msk.ru> <54363ED0.605@broadcom.com> <CACna6rw3XgdJz0uKkAuas8RTzozTdFp2mgF5g1uo7LHJVSMt4g@mail.gmail.com> <3543341.FmUQFH9nrl@eisbaer> <546C5D1F.108@msgid.tls.msk.ru> <546CD94D.9060509@broadcom.com> <546CF66A.3000207@msgid.tls.msk.ru> <546D04EE.1030200@msgid.tls.msk.ru> <5471AC29.6040009@broadcom.com> <5475A2DC.80502@msgid.tls.msk.ru> <547B07CF.90501@broadcom.com>
In-Reply-To: <547B07CF.90501@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

30.11.2014 15:04, Arend van Spriel wrote:

> Thanks. Did not find what I was looking for, but I started working on
> integrating btcoex related functionality. The attached patch will print
> some info so I can focus on the required functionality for your device.
> It is based on 3.18-rc5.

With this patch applied against 3.18-rc5, the machine instantly reboots
once brcmsmac module is loaded.  I'm still debugging this.

Thanks,

/mjt
