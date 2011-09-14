Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45402 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1INEJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 00:09:12 -0400
Received: by gyg10 with SMTP id 10so1099121gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 21:09:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110913080246.184260@gmx.net>
References: <20110913080246.184260@gmx.net>
Date: Wed, 14 Sep 2011 12:09:12 +0800
Message-ID: <CAJ-Vmo=q=aJ73Y8sOv_fTNCDM=DhB7Cp0C0NGHpS-GXY=77tHw@mail.gmail.com> (sfid-20110914_060919_121820_3118D787)
Subject: Re: AR9170 chipset details
From: Adrian Chadd <adrian@freebsd.org>
To: Louis <louis.m@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 September 2011 16:02, Louis <louis.m@gmx.net> wrote:
> Hello,
>
> I need a detailed description of the Atheros AR9170 chipset.

You're not going to find anything publicly detailed, unfortunately.

> Since Qualcomm and Atheros merged, there are only descriptions of the most recent chips available on their homepage and even not in the detailed depth I would like to have.

What kind of detailed descriptions are you after?

> Does someone know if there is a reference guide or a detailed datasheet with the chip`s functions and register descriptions available somewhere.

There's nothing private. There may be documentation available if
you're working on open source AR9170 support.

> On which information base has the carl91790 driver been developed?

The Otus firmware sources were thrown into a git repository a while
ago; I believe this formed a base for some of the AR9170 open source
work.

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/otus.git

Other than that, Christian is likely the best person to talk to as
he's the AR9170 firmware maintainer.



adrian
