Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:34287 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbZCZRPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 13:15:12 -0400
Received: by wf-out-1314.google.com with SMTP id 29so787960wff.4
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 10:15:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0903261752470.11410@aurora.sdinet.de>
References: <b49006ab0903260414xad13bd5y370a47020348c66f@mail.gmail.com>
	<b49006ab0903260822r35417242qbdc6889543de7072@mail.gmail.com>
	<alpine.DEB.2.00.0903261752470.11410@aurora.sdinet.de>
Date: Thu, 26 Mar 2009 10:14:55 -0700
Message-ID: <43e72e890903261014j7d050d44wf72ab2c25bc8d625@mail.gmail.com> (sfid-20090326_181515_771139_45C9DFC3)
Subject: Re: Driver Support Linux 2.4.26 zd1211
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Paco <eyes2k5@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 9:55 AM, Sven-Haegar Koch <haegar@sdinet.de> wrote:
> On Thu, 26 Mar 2009, Paco wrote:
>
>> Hello everybody, and sorry if I disturb you with something that was
>> fixed before.
>>
>> I'm trying to setup the zd1211 in Linux 2.4.26-ts11 in the board
>> TS-7200. I have some drivers that are working only with networks
>> without encryption. If I try to connect to a network with WEP or WPA
>> encryption, i can not get the access point. I am looking for a new
>> version of drivers to solve this problem.
>
> I think for 2.4.x: forget it.
>
> For 2.6.26 it may be possible using compat-wireless-old,

Actually with compat-wireless-old you can go down to 2.6.21 but keep
in mind that the drivers in there, nor mac80211 has been updated in
ages.

  Luis
