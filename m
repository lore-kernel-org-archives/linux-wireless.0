Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57943 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1FMNC0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 09:02:26 -0400
Received: by yia27 with SMTP id 27so943290yia.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 06:02:25 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Jun 2011 21:01:57 +0800
Message-ID: <BANLkTikFvkUj=JFrCsffz6Z78KdAEw-t0A@mail.gmail.com> (sfid-20110613_150235_103414_29334452)
Subject: Re: APSM, AR9285 and bus hangs
From: Adrian Chadd <adrian@freebsd.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, ath9k-devel@venema.h4ckr.net,
	Tony Houghton <h@realh.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	camilo@mesias.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 June 2011 19:00, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> cam a fedora user, confirms that patch fixes the locks-ups
> https://bugzilla.redhat.com/show_bug.cgi?id=697157#c26
>
> We are waiting for fix now :-)

Cool.

The problem is, the initial modification and subsequent changes to the
powersave function were documented to fix an APSM hang, not cause it.

I'm happy to submit a patch to undo that particular change but I'm not
sure if it'll -break- things for other people. :)

Someone with PCIe/APCI/APSM/general clue in the area of CPU + bus
sleep states needs to step in and help. I'm just not equipped to fix
the problem at the moment.

Thanks,


Adrian
