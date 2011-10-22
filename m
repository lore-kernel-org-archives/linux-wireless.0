Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39321 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab1JVH3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 03:29:42 -0400
Received: by ywm3 with SMTP id 3so228098ywm.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 00:29:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111022072215.GA2524@ecki>
References: <CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
	<CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com>
	<20111015093902.GA23520@ecki>
	<CAJ-VmokQBcXyDByWgMfGRFvW_z_9YU4oPUrXJpfPY9J4riEuBQ@mail.gmail.com>
	<20111018064459.GA1442@ecki>
	<CAJ-Vmo=Qt3rGDbM0yOvFuz6Pksdx9bdm8HEBnhfjP6=zjGOgTA@mail.gmail.com>
	<20111021102221.GA1463@ecki.lan>
	<CAJ-Vmonaec_i5d_LGupY5uwzMUn3CzNn-rGSh6oqLOHc8ewFVg@mail.gmail.com>
	<20111021202038.GA1523@ecki.lan>
	<CAJ-Vmonu-75rtOyyqP7aWNA5NvQ7XW+0YB-G7N5gF3tS5E0EaA@mail.gmail.com>
	<20111022072215.GA2524@ecki>
Date: Sat, 22 Oct 2011 15:29:42 +0800
Message-ID: <CAJ-Vmo=KiTB=ZfGH50rYVCWt5D0GHiNAkH0VLpY=mLt9NJQeRw@mail.gmail.com> (sfid-20111022_092946_212519_17ABD172)
Subject: Re: ath9k: irq storm after suspend/resume
From: Adrian Chadd <adrian@freebsd.org>
To: Clemens Buchacher <drizzd@aon.at>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 October 2011 15:22, Clemens Buchacher <drizzd@aon.at> wrote:

> Looks like you had it right from the start. After unloading the jme
> module [*1*] I cannot reproduce the IRQ storm any more. From
> looking at dmesg it should have been obvious, since it also gets
> IRQ 17 assigned. I don't know how I missed that, I was sure I had
> checked.
>
> Sorry guys, for most likely wasting your time. And thanks for your
> patience.

Ah, eek! Well, you're welcome! And I hope you/others have a better
understanding of how the interrupt setup on these NICs work.
(I certainly have a better understanding now of the host interface and
what we can poke when it's awake and asleep.)

Good luck!



Adrian
