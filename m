Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab1KWOiR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 09:38:17 -0500
Date: Wed, 23 Nov 2011 15:40:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
Message-ID: <20111123144041.GB13460@redhat.com> (sfid-20111123_153839_012073_8FAF2A9F)
References: <20111116100915.GA2191@redhat.com>
 <20111122214940.GH8452@tuxdriver.com>
 <20111123080506.GB9833@redhat.com>
 <CAGXE3d-HE8MWV5Xv9e407iDn83UFvjua52mYGEJuJnQuQvnyog@mail.gmail.com>
 <20111123105106.GA7943@redhat.com>
 <CAHJ2optb4E2r6W2w21oswptZh=_Q9kB+RbQ=F0TWg9zHGjXwZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHJ2optb4E2r6W2w21oswptZh=_Q9kB+RbQ=F0TWg9zHGjXwZA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

(adding CCes again, please keep them next time :-)

On Wed, Nov 23, 2011 at 10:54:03AM +0000, Luis Correia wrote:
> this suggestion won't really help much, but you could try also booting
> with the 'irqpoll' option.
> 
> This slows down a bit all interrupt processing but can help to
> investigate situations in where the IRQ lines are really shared.

Thanks, this is a good hint. I think irqpoll option can be used
as workaround for the bug.

Stanislaw
