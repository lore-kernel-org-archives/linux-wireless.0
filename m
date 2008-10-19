Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:24208 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYJSP56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 11:57:58 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1433091rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2008 08:57:58 -0700 (PDT)
Message-ID: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com> (sfid-20081019_175802_420418_5990D116)
Date: Sun, 19 Oct 2008 17:57:58 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: crda packaging
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/28 Luis R. Rodriguez <mcgrof@gmail.com>:
> On Sat, Sep 27, 2008 at 9:59 AM, Davide Pesavento <davidepesa@gmail.com> wrote:
>> 2008/9/16 Johannes Berg <johannes@sipsolutions.net>:
>>> Anyone want to pick it up for the various distros?
>>
>> I've written an ebuild for Gentoo and attached it to bug #238879.
>> https://bugs.gentoo.org/show_bug.cgi?id=238879
>
> Would you be able to start packaging crda as well? It'll be very good
> to have this by 2.6.28 and if you guys have a compat-wireless, it will
> soon require it (by 2.6.29).
>

I'll be glad to help ;)

> The regulatory.bin and the rsa public key will soon be posted on some
> place on John Linville's web space somewhere, so that'll change soon I
> hope.
>

Do you think the regulatory database should be split from the package
that contains the crda daemon? If so, regulatory.bin should be
versioned as well...
