Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52911 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1E3Nmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 09:42:53 -0400
Received: by pzk9 with SMTP id 9so1614290pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 06:42:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110530125221.GD2417@redhat.com>
References: <20110529104529.GA2769@localhost.localdomain>
	<4DE278CD.3030708@gmail.com>
	<20110529204200.GA2472@localhost.localdomain>
	<4DE3380C.2@gmail.com>
	<20110530095259.GB2417@redhat.com>
	<BANLkTi=Hcqd3rJtzhY3RnnNydb63_gyUAg@mail.gmail.com>
	<20110530125221.GD2417@redhat.com>
Date: Mon, 30 May 2011 15:42:52 +0200
Message-ID: <BANLkTi=MifiwVUo-Qx=6qNU3oBBBZvVC3Q@mail.gmail.com> (sfid-20110530_154256_809199_1D6FD3F0)
Subject: Re: [PATCH wireless-2.6] rt2x00: fix rmmod crash
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 30, 2011 at 2:52 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, May 30, 2011 at 01:26:37PM +0200, Gertjan van Wingerde wrote:
>> > It's not stable fix, this bug was introduced currently by
>> >
>> > commit 1c0bcf89d85cc97a0d9ce4cd909351a81fa4fdde
>> > Author: Ivo van Doorn <ivdoorn@gmail.com>
>> > Date:   Sat Apr 30 17:18:18 2011 +0200
>> >
>> >    rt2x00: Add autowake support for USB hardware
>> >
>>
>> I cannot check it right now, but that patch is not yet included in
>> wireless-2.6, which
>> you indicate (in the email subject) as being the target for this patch.
>> Which tree do you want this patch to be applied to?
>
> Oh, indeed. But it is in current Linus' tree, patch is targeted there.
>

OK. Everything is clear now.

Personally I am okay with your patch; however, I would like for Ivo to
comment, as it was his patch
that caused the issues in the first place.

---
Gertjan
