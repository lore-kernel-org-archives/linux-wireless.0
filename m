Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33628 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbcDAU3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 16:29:00 -0400
Received: by mail-ig0-f181.google.com with SMTP id ma7so5205541igc.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2016 13:29:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1226946591.551679.1459474349098.JavaMail.yahoo@mail.yahoo.com>
References: <CAJ-VmonT5AWXzstdxbR+R6p4ia-ui6WFaQ9Tq28TzLd-uh4dUw@mail.gmail.com>
	<1226946591.551679.1459474349098.JavaMail.yahoo@mail.yahoo.com>
Date: Fri, 1 Apr 2016 13:28:59 -0700
Message-ID: <CAJ-VmokAypMZGWJ5BEnFpnBcYFZ=i7j-sgjpYjZB1KT+zHd5mA@mail.gmail.com> (sfid-20160401_222904_071647_12503C0A)
Subject: Re: Bonjour mDNS broacast can be lost during BT-WLAN coexistence schemes?
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Ath9k-devel <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

ath9k has support for station powersave, and it's driven by mac80211.
You should be able to implement that policy in mac80211 and then add
hooks so your bluetooth code can get notifications about it.


-a
