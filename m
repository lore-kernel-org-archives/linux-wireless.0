Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62416 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3EVIRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 04:17:04 -0400
Received: by mail-lb0-f179.google.com with SMTP id r11so1759217lbv.38
        for <linux-wireless@vger.kernel.org>; Wed, 22 May 2013 01:17:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP8Jb=oTE_tL+57_wtMo_QTNG01_oP2jgjicrDneFwTuOocs8g@mail.gmail.com>
References: <CAP8Jb=oTE_tL+57_wtMo_QTNG01_oP2jgjicrDneFwTuOocs8g@mail.gmail.com>
Date: Wed, 22 May 2013 11:17:01 +0300
Message-ID: <CANUX_P1zU-ntkdb33taPz=0qw2Xy-bp3jdA-C7eqXX-wbebMGA@mail.gmail.com> (sfid-20130522_101708_835095_3A371A65)
Subject: Re: Problem with iwlwifi kernel 3.9.0 and 3.9.2
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Flavio <fbcyborg@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 21, 2013 at 12:26 AM, Flavio <fbcyborg@gmail.com> wrote:
> Hello,
>
> I've recently changed my wifi router and I'm experiencing something
> really strange with my wifi connection.
> If I try to connect to my access point using windows, I don't have any
> problem, but if I try with Linux (Gentoo Linux
> x86_64) I cannot connect to my Access Point unless I do the following steps:
>
> ifconfig wlan0 down
> rmmod iwldvm
> rmmod iwlwifi
> modprobe iwlwifi
> ifconfig wlan0 up
>
> otherwise if I try to connect to my access point / wifi router, Wicd
> tells me that I inserted a wrong password.
> I've even tried with another live linux distribution, and I don't have
> this issue.
>

Please try the patch attached in
https://bugzilla.kernel.org/show_bug.cgi?id=58341
