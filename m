Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34119 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbdB0Wz3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 17:55:29 -0500
MIME-Version: 1.0
In-Reply-To: <20170227234813.2a077471@tock>
References: <1488227292-18906-1-git-send-email-albeu@free.fr>
 <1488227292-18906-4-git-send-email-albeu@free.fr> <CACna6rzZ-UiJR8oBJ9oHE+ZNT=nm6oLiKyW4bsiZ34TMRDh5Xw@mail.gmail.com>
 <20170227234813.2a077471@tock>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 27 Feb 2017 23:54:38 +0100
Message-ID: <CACna6rzZufOWrztGE+W=RnsewVa4izxyuimgVx=FkE4weiZ1-A@mail.gmail.com> (sfid-20170227_235757_641110_E53647E7)
Subject: Re: [PATCH 3/3] ath9k: ahb: Add OF support
To: Alban <albeu@free.fr>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Richard Weinberger <richard@nod.at>,
        Marek Vasut <marek.vasut@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 February 2017 at 23:48, Alban <albeu@free.fr> wrote:
> On Mon, 27 Feb 2017 22:13:21 +0100
> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
>
>> Why you didn't cc linux-wireless?!?!
>
> I first wanted to be sure that the devdata part was generally
> acceptable, this patch was just included as an example of a user.
> But it sound like that part will have to move to nvmem first.
> I'll come back with a new patch once MTD support for nvmem is
> done.

OK, I just realized this was supposed to be RFC (for some reason this
patch didn't include RFC tag). At least this is was I assume to by
looking at the:
[RFC 0/3] drivers: Add an API to read device specific config data

Good luck!
