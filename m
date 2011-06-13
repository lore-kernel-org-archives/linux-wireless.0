Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33683 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1FMNJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 09:09:55 -0400
Received: by vws1 with SMTP id 1so3572039vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 06:09:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikFvkUj=JFrCsffz6Z78KdAEw-t0A@mail.gmail.com>
References: <BANLkTikFvkUj=JFrCsffz6Z78KdAEw-t0A@mail.gmail.com>
Date: Mon, 13 Jun 2011 14:09:54 +0100
Message-ID: <BANLkTinNT8=NYu4Dh2sR-JpG0fJ12+kMiQ@mail.gmail.com> (sfid-20110613_150958_729670_6EFF91A6)
Subject: Re: APSM, AR9285 and bus hangs
From: Camilo Mesias <camilo@mesias.co.uk>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@venema.h4ckr.net, Tony Houghton <h@realh.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Jun 13, 2011 at 2:01 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> I'm happy to submit a patch to undo that particular change but I'm not
> sure if it'll -break- things for other people. :)

I was wondering if it would be a pragmatic approach to let people turn
off APSM somehow. During testing I tried the pcie_aspm=off boot option
but got the impression the ath9k driver didn't honour it. Maybe an
option to the driver specifically to let people configure the
workaround?

With the tweaked driver my netbook has gone from practically useless
to almost completely satisfactory, so I see this as an important fix
to make available to the general public somehow.

-Cam
