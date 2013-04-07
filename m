Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:41271 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934189Ab3DGRtW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 13:49:22 -0400
Received: by mail-we0-f172.google.com with SMTP id r3so3953206wey.31
        for <linux-wireless@vger.kernel.org>; Sun, 07 Apr 2013 10:49:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51614F9E.9010109@gmail.com>
References: <loom.20130403T092722-24@post.gmane.org>
	<CAJ-Vmomn8A77jEvR2c312QukWy7Zozs4T2NQuiYMForr5+DthQ@mail.gmail.com>
	<515E9D1F.8000701@gmail.com>
	<CAJ-Vmok__=unaWchTzB6_ExM+P_krc4MmMNJ-9C-=We9NUGjGQ@mail.gmail.com>
	<CAMqNPvLAea9N2eSjkNo7s-4aNFoQMfkSDesTxfZFSiNWXdHB2w@mail.gmail.com>
	<CAJ-Vmoko0UOztAy2coQ2+XCqqiiPZN-6=mssCb1+5gFPwDBAdw@mail.gmail.com>
	<51614F9E.9010109@gmail.com>
Date: Sun, 7 Apr 2013 10:49:20 -0700
Message-ID: <CAJ-VmomtFvXuQtj-Kxs5QPcptO-QWsySkTEzWTC1XzG1zdbU2g@mail.gmail.com> (sfid-20130407_194928_544363_C732A1EE)
Subject: Re: [ath5k][802.11p] Deactivate beacon
From: Adrian Chadd <adrian@freebsd.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	=?ISO-8859-1?Q?Ricardo_Tub=EDo_Pardavila?= <rtpardavila@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 April 2013 03:51, Nick Kossifidis <mickflemm@gmail.com> wrote:

> I don't know, so far I 've talked with many people about 802.11p, I 've
> helped most of them with their implementations and so far we have no
> incoming patches. They just don't seem to care if 802.11p support goes
> into mainline.

Shocking!

:-)

One of the FreeBSD wifi developers has nicely built a table for what's
needed for 802.11p support, at least from the kernel side. I'll get it
tidied up and pushed online so we can both take a stab at fixing up
the kernel/driver support.

Some of it is mostly done in linux (half/quarter rate), we will need a
new mode where beacons are disabled; but the fun bits are stuff like
the QoS configuration parameters, time synchronisation stuff and
apparently some requirement that channel change happen within a TU.

That last one? Full of hilarity.



Adrian
