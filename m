Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:39023 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbZFWUzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 16:55:23 -0400
Received: by gxk10 with SMTP id 10so601037gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2009 13:55:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A413F97.9060601@gmail.com>
References: <43e72e890906220847u4faaeb2paa15365360c3c080@mail.gmail.com>
	<4A3FDAC2.7020209@gmail.com> <43e72e890906221358m4a32d747ge67a5af2f74841e0@mail.gmail.com>
	<4A4009C6.8020208@gmail.com> <43e72e890906222228qc131509j48d1946eb58db6b0@mail.gmail.com>
	<4A413C1B.2070700@gmail.com> <43e72e890906231340l12a92b32o4fa999a423e1570b@mail.gmail.com>
	<4A413F97.9060601@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 23 Jun 2009 13:55:05 -0700
Message-ID: <43e72e890906231355k1b7336b6v36cb9b463c3d77df@mail.gmail.com>
Subject: Re: [ath9k-devel] Pending ath9k bugs June, 2009
To: Dmitri Seletski <drjoms@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	gaurav.jauhar@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 23, 2009 at 1:48 PM, Dmitri Seletski<drjoms@gmail.com> wrote:

> i have an idea.
> i can try older drivers, something that was working with me before
> perhaps, if it ever was... and if it does somewhat work, well, it'll be
> rather easy to trace where problem came from.
> Only question is, where can i see archives? i don't feel like using
> developers tools, i am not developer and probably not bright enough to
> use them anyway...

Hm, well, there are the compat-wireless tarballs:

http://www.orbit-lab.org/kernel/compat-wireless-2.6/

These would not require git, etc. And the nice thing is they have
John's wireless-testing tag from which the code was pulled from so if
you *do* find a working release then this issue should be bisectable,
but for that you will need git.

> BTW, if anyone from developers is based in Republic of Ireland - i could
> perhaps travel to him/her with ap and wifi card :)

If you want to attend this week's Linux wireless summit in Berlin
there were will be plenty of folks there.

http://wireless.kernel.org/en/developers/Summits/Berlin-2009

  Luis
