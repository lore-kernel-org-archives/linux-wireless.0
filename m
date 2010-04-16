Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54976 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab0DPSHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 14:07:24 -0400
Received: by wwb24 with SMTP id 24so1345245wwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 11:07:23 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <19389.36279.77368.650461@gargle.gargle.HOWL>
References: <i2i2d0a357f1004060442sc332438bz4873484aa794aa2a@mail.gmail.com>
	 <19389.36279.77368.650461@gargle.gargle.HOWL>
Date: Fri, 16 Apr 2010 20:07:22 +0200
Message-ID: <m2y2d0a357f1004161107h2881b448ta8aebbc7fbc40486@mail.gmail.com>
Subject: Re: [ath9k_htc] Current patches against 2.6.34-rc3-git4
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the informations.

Compat-wireless is broken ATM (see IRC backlog below).

>From #linux-wireless/freenode (German local-time - UTC+2):
...
[06:52:54] <mcgrof> User-level discussions about wireless LANs on
Linux | compat-wireless-2.6 only available for kernels >= 2.6.23
(bleeding edge broken right now though)
...
[19:13:41] <jensp> fivetwentysix: He says that he removed the atheros
driver from compat-wireless and replaced it with
http://git.kernel.org/?p=linux/kernel/git/mcgrof/ath9k_htc.git;a=summary
...

I was more interested in following the ath9k_htc development -
especially against Linus-tree.

A GIT repository like in [1] w/could be helpful and if it is
"official" (don't know the status, last commit was before 7 weeks)
worth updating in [2]?

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/mcgrof/ath9k_htc.git;a=summary
[2] http://wireless.kernel.org/en/users/Drivers/ath9k_htc/

On Thu, Apr 8, 2010 at 10:03 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Sedat Dilek wrote:
>> Hi,
>>
>> I (hope I) collected all ath9k_htc patches pending in [1].
>> Unfortunately, my (quilt) series break against Linux 2.6.34-rc3-git4.
>> Any hints?
>
> An easier way to get the latest wireless drivers would be to use
> compat-wireless.
>
> See: http://linuxwireless.org/en/users/Download/
>
> Sujith
>
