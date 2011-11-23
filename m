Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35007 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1KWOpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 09:45:55 -0500
Received: by wwe5 with SMTP id 5so2380731wwe.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 06:45:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111123144041.GB13460@redhat.com>
References: <20111116100915.GA2191@redhat.com> <20111122214940.GH8452@tuxdriver.com>
 <20111123080506.GB9833@redhat.com> <CAGXE3d-HE8MWV5Xv9e407iDn83UFvjua52mYGEJuJnQuQvnyog@mail.gmail.com>
 <20111123105106.GA7943@redhat.com> <CAHJ2optb4E2r6W2w21oswptZh=_Q9kB+RbQ=F0TWg9zHGjXwZA@mail.gmail.com>
 <20111123144041.GB13460@redhat.com>
From: Luis Correia <luis.f.correia@gmail.com>
Date: Wed, 23 Nov 2011 14:45:13 +0000
Message-ID: <CAHJ2opsjJ8bG7a5cB3nLq28m5rKOcQuWpCZTH5Afbdwf1iBtpg@mail.gmail.com> (sfid-20111123_154558_543537_17739A21)
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, Nov 23, 2011 at 14:40, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hi Luis,
>
> (adding CCes again, please keep them next time :-)

Sorry about the mess, I was in a hurry to leave and really wanted to
provide feedback.

>
> On Wed, Nov 23, 2011 at 10:54:03AM +0000, Luis Correia wrote:
>> this suggestion won't really help much, but you could try also booting
>> with the 'irqpoll' option.
>>
>> This slows down a bit all interrupt processing but can help to
>> investigate situations in where the IRQ lines are really shared.
>
> Thanks, this is a good hint. I think irqpoll option can be used
> as workaround for the bug.
>
> Stanislaw
>

The last time I used it, it really did avoid kernel panic because the
two drivers that were sharing the same IRQ line were misbehaving.

Luis Correia
