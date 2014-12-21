Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:45380 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaLUJ6v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 04:58:51 -0500
Message-ID: <549699D9.2060106@msgid.tls.msk.ru> (sfid-20141221_105856_667773_07FA4CA9)
Date: Sun, 21 Dec 2014 12:58:49 +0300
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
References: <53FDACD1.8090805@msgid.tls.msk.ru> <54363ED0.605@broadcom.com> <CACna6rw3XgdJz0uKkAuas8RTzozTdFp2mgF5g1uo7LHJVSMt4g@mail.gmail.com> <3543341.FmUQFH9nrl@eisbaer> <546C5D1F.108@msgid.tls.msk.ru> <546CD94D.9060509@broadcom.com> <546CF66A.3000207@msgid.tls.msk.ru> <546D04EE.1030200@msgid.tls.msk.ru> <5471AC29.6040009@broadcom.com> <5475A2DC.80502@msgid.tls.msk.ru> <547B07CF.90501@broadcom.com> <547E31BD.8090302@msgid.tls.msk.ru> <547F0575.7010104@broadcom.com> <549062FE.2000808@broadcom.com>
In-Reply-To: <549062FE.2000808@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

16.12.2014 19:51, Arend van Spriel wrote:

> Hmm. The function brcms_btc_ecicoex_enab() is calling itself. Please remove that call as it causes endless recursion and eventually reboot.

Ok, that was easy.  Now it loads, but wifi link still
does not work, stalling as before.  What we're looking
at now?

(To have a common base, I applied this bt-coex patch to
3.18.0 kernel.  I can also apply the previously mentioned
debugging/stats patch too).

Thanks,

/mjt
