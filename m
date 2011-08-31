Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37629 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab1HaVSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 17:18:13 -0400
Received: by pzk37 with SMTP id 37so1898250pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:18:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E5E9E16.3030306@lwfinger.net>
References: <D23A4EC8-E27C-476C-BA73-64EAB4E81B62@ncsu.edu>
	<4E5E9E16.3030306@lwfinger.net>
Date: Wed, 31 Aug 2011 23:18:12 +0200
Message-ID: <CACna6rzWHjwZi3jyhyPmPcjCjTTGJSSb0Y-g9PKT0_aQ=Tm-PA@mail.gmail.com> (sfid-20110831_231816_513809_D23197E0)
Subject: Re: Status of BCM4331
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Matthew Frazier <mlfrazie@ncsu.edu>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/31 Larry Finger <Larry.Finger@lwfinger.net>:
> On 08/31/2011 03:27 PM, Matthew Frazier wrote:
>>
>> Hello, Linux wireless people.
>>
>> On the b43 device list[1], you have support for the BCM4331 listed as
>> "Soon (3.2+)". Does this mean "it will be in 3.2," "we will start working on
>> it after 3.2," or something else?
>
> Support for that chip will be in kernel 3.2. In fact, the code now in the
> wireless testing git tree handles that chip without any other changes (as of
> the August 30 update).

Matthew: you should just apply one more patch to make performance on
BCM4331 much better:
http://files.zajec.net/0001-b43-ctl1-on-all-new-PHYs.patch

This patch still waits for updating specs [1] before going mainline
(ping Larry about that ;) )

[1] http://bcm-v4.sipsolutions.net/802.11/PHY/TxControl1

-- 
Rafał
