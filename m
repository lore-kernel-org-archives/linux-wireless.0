Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60870 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2ERF7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 01:59:39 -0400
Received: by obbtb18 with SMTP id tb18so3510904obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 22:59:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337252722.4332.1.camel@jlt3.sipsolutions.net>
References: <1336479518-23006-1-git-send-email-yoni.divinsky@ti.com>
	<1336485961.4320.1.camel@jlt3.sipsolutions.net>
	<CANJm+iAoVkPOO61ufrM3mxzsURFZzuNcMm9N6Y=3xUbSCaC1+w@mail.gmail.com>
	<1337072920.4546.0.camel@jlt3.sipsolutions.net>
	<CANJm+iDif1+KREB=CJ_wYbo+Hzxo=nJL6fUxbBTQ5_C8Tz0E9Q@mail.gmail.com>
	<CANJm+iDU1ahy3B9u6nn=0E4d0Pge+OubaNE9bPaE1EXYGahOUA@mail.gmail.com>
	<CAEZZmbEExFr6=7G6kQb_bbpt=wfiNDuoR+U4_Eu_wLdair=SrA@mail.gmail.com>
	<CAEZZmbF6wa3JF48KsCiyg4T7OsBS73OnzAMVYPkPdPro9EYUtg@mail.gmail.com>
	<1337252722.4332.1.camel@jlt3.sipsolutions.net>
Date: Fri, 18 May 2012 11:29:38 +0530
Message-ID: <CAEZZmbG=KY9K32uxTV=K+osrOT1HOUgA_FPpYQiZTP_tRBRhwA@mail.gmail.com> (sfid-20120518_075943_583258_DBD4CD7D)
Subject: Re: [PATCH] mac80211: add op to configure default key id to driver
From: Ravi Sharma <sharmaravi.lx@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Divinsky, Yonatan" <yoni.divinsky@ti.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am describing another scenario where we may use this patch.

The patch heading says 'mac80211: add op to configure default key id to driver'.

Its upto you and Yoni to decide.



On Thu, May 17, 2012 at 4:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-05-17 at 14:06 +0530, Ravi Sharma wrote:
>> Hi All
>> I know this use case is quite trivial looking regarding WEP (Since it
>> is going to be deprecated), we faced a issue with minap (softap) in
>> WEP security with auth mode as shared. Since the default key is not
>> passed to driver, we can not program firmware default key idx (default
>> key is programmed when data packet exchange started, looking into type
>> of encryption) and the handshake failed in shared auth mode. In open
>> mode, there is no need for this.
>
> Now you're talking about something else entirely? What does this have to
> do with auto-ARP responses??
>
> Can we get that story straight? :-) And then a patch that actually
> explains & documents it ... Remember that the changelog should indicate
> why you're changing something.
>
> johannes
>
