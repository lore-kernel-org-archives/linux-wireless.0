Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53245 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1GULxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 07:53:31 -0400
Received: by vxh35 with SMTP id 35so814193vxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 04:53:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107201709.42141.helmut.schaa@googlemail.com>
References: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com>
	<201107201536.01392.helmut.schaa@googlemail.com>
	<CAN=pzdKLtB2yz4-OhKL5gzYF0Qm2weAmNAz-0MqdFuooFNYzwQ@mail.gmail.com>
	<201107201709.42141.helmut.schaa@googlemail.com>
Date: Thu, 21 Jul 2011 15:53:30 +0400
Message-ID: <CAN=pzdL7baXMVORm6CDh4Py773jbFBFkfRUKhjbL0ATZ_yvJmg@mail.gmail.com> (sfid-20110721_135334_799795_D6FC3863)
Subject: Re: rt2x00, AP mode, 802.11n is not working properly
From: Stanislav Demakov <s.demakov@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

So eventually, are you going to fix or discover this bug yourself?

2011/7/20 Helmut Schaa <helmut.schaa@googlemail.com>:
> Am Mittwoch, 20. Juli 2011 schrieb Stanislav Demakov:
>> 2011/7/20 Helmut Schaa <helmut.schaa@googlemail.com>:
>> > Am Mittwoch, 20. Juli 2011 schrieb Stanislav Demakov:
>> >> I'm using hostapd 0.73 and 1T1R rt2x00 based wireless dongle to create
>> >> an AP. The problem is that since version
>> >> compat-wireless-2010-12-14.tar.bz2 802.11n mode is not working
>> >> properly. In this driver version and all later you've broken
>> >> something!
>> >
>> > So, 2010-12-14 already shows the problem you've described while 2010-12-13
>> > does not, right?
>> Yes, correct.
>
> One major change from 12-13 to 12-14 was the queue refactoring. Haven't found
> anything else that looks related. However, this patchset is quite big and
> really changed the way the queues are handled in rt2x00. So it's not trivial
> to find the root cause for your problem ...
>
> Helmut
>
