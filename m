Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:44843 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3ENGk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 May 2013 02:40:58 -0400
Received: by mail-la0-f41.google.com with SMTP id lx15so156893lab.0
        for <linux-wireless@vger.kernel.org>; Mon, 13 May 2013 23:40:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <034c01ce506a$50d75d90$f28618b0$@necst.nec.co.jp>
References: <034c01ce506a$50d75d90$f28618b0$@necst.nec.co.jp>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 13 May 2013 23:40:36 -0700
Message-ID: <CAB=NE6Wu8C2P52D_13-rnOXw3SW2dW71PLmz3HBSKYhbyy7Z+Q@mail.gmail.com> (sfid-20130514_084103_349741_7571A6D3)
Subject: Re: switch user id in crda
To: Tetsuo Tatsugami <tatsugami-txa@necst.nec.co.jp>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 13, 2013 at 11:14 PM, Tetsuo Tatsugami
<tatsugami-txa@necst.nec.co.jp> wrote:
> Dear mcgrof,
>
> My name is Tetsuo Tatsugami.
> I work for NEC CASIO Mobile communications, Ltd.
> We are using Qualcomm APQ 8064 chipset in our device.
>
> We requested the modification of crda to Qualcomm support team,
> and they said that I could send the patches to you.
> Because the crda is open source code.
>
>
> Our modification for crda:
> The crda is executed by root user to use netlink socket.
> It's better to minimize the capabilities for security reason.
> The crda can work if it has CAP_NET_ADMIN capabilities.
>
> I attached the patch in this mail.
> It worked well in our device.

Tetsuo, thanks so much for the patch but unfortunately in order to
facilitate patch review we need developers to engage with the
community through our standard practice of submitting patches inline
in ASCII text, not as attachments. Its also encouraged if you have
multiple patches that you enumerate them and also provide a good
commit log message. As for CRDA we also use the DCO so be sure to read
the DCO and then if you agree be sure to add the Signed-off-by tag to
each patch.

This git guide is specific to 802.11 Linux wireless kernel development
but it contains sufficient examples of how to configure git, ssmtp,
etc to help you get patches out to me and the community that enables
community review:

http://wireless.kernel.org/en/developers/Documentation/git-guide

Please let me know if you have any questions. I cannot stress the
importance of a good commit log message. If in doubt just check git
log on the project for other holder commit log messages for examples.

Can you resend with git format-patch ?

  Luis
