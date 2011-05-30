Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1E3Mwo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 08:52:44 -0400
Date: Mon, 30 May 2011 14:52:21 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-2.6] rt2x00: fix rmmod crash
Message-ID: <20110530125221.GD2417@redhat.com> (sfid-20110530_145247_997555_CEDACE0D)
References: <20110529104529.GA2769@localhost.localdomain>
 <4DE278CD.3030708@gmail.com>
 <20110529204200.GA2472@localhost.localdomain>
 <4DE3380C.2@gmail.com>
 <20110530095259.GB2417@redhat.com>
 <BANLkTi=Hcqd3rJtzhY3RnnNydb63_gyUAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <BANLkTi=Hcqd3rJtzhY3RnnNydb63_gyUAg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 30, 2011 at 01:26:37PM +0200, Gertjan van Wingerde wrote:
> > It's not stable fix, this bug was introduced currently by
> >
> > commit 1c0bcf89d85cc97a0d9ce4cd909351a81fa4fdde
> > Author: Ivo van Doorn <ivdoorn@gmail.com>
> > Date:   Sat Apr 30 17:18:18 2011 +0200
> >
> >    rt2x00: Add autowake support for USB hardware
> >
> 
> I cannot check it right now, but that patch is not yet included in
> wireless-2.6, which
> you indicate (in the email subject) as being the target for this patch.
> Which tree do you want this patch to be applied to?

Oh, indeed. But it is in current Linus' tree, patch is targeted there.

Stanislaw
