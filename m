Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:45142 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaLUKMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 05:12:43 -0500
Message-ID: <54969D18.3060000@broadcom.com> (sfid-20141221_111316_811129_C0DCE7F1)
Date: Sun, 21 Dec 2014 11:12:40 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Maximilian Engelhardt <maxi@daemonizer.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Subject: Re: BCM4313 & brcmsmac & 3.12: only semi-working?
References: <53FDACD1.8090805@msgid.tls.msk.ru> <54363ED0.605@broadcom.com> <CACna6rw3XgdJz0uKkAuas8RTzozTdFp2mgF5g1uo7LHJVSMt4g@mail.gmail.com> <3543341.FmUQFH9nrl@eisbaer> <546C5D1F.108@msgid.tls.msk.ru> <546CD94D.9060509@broadcom.com> <546CF66A.3000207@msgid.tls.msk.ru> <546D04EE.1030200@msgid.tls.msk.ru> <5471AC29.6040009@broadcom.com> <5475A2DC.80502@msgid.tls.msk.ru> <547B07CF.90501@broadcom.com> <547E31BD.8090302@msgid.tls.msk.ru> <547F0575.7010104@broadcom.com> <549062FE.2000808@broadcom.com> <549699D9.2060106@msgid.tls.msk.ru>
In-Reply-To: <549699D9.2060106@msgid.tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/14 10:58, Michael Tokarev wrote:
> 16.12.2014 19:51, Arend van Spriel wrote:
>
>> Hmm. The function brcms_btc_ecicoex_enab() is calling itself. Please remove that call as it causes endless recursion and eventually reboot.
>
> Ok, that was easy.  Now it loads, but wifi link still
> does not work, stalling as before.  What we're looking
> at now?

The patch is just to provide me with extra bt-coex related information 
in the kernel log. So if you can provide that to me I have to info 
needed to look in the proprietary code base to determine what is missing.

Regards,
Arend

> (To have a common base, I applied this bt-coex patch to
> 3.18.0 kernel.  I can also apply the previously mentioned
> debugging/stats patch too).
>
> Thanks,
>
> /mjt

