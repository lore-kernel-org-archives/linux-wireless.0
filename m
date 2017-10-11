Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.185]:50803 "EHLO
        smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751991AbdJKMy2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 08:54:28 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: 'Joe Perches' <joe@perches.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arnaldo Carvalho de Melo" <acme@infradead.org>
Subject: RE: [PATCH] rtl8xxxu: mark expected switch fall-throughs
Date: Wed, 11 Oct 2017 12:54:24 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DD009123C@AcuExch.aculab.com> (sfid-20171011_145457_253662_BE29BE26)
References: <20171010193027.GA23108@embeddedor.com>
 <1507717237.3552.48.camel@perches.com>
In-Reply-To: <1507717237.3552.48.camel@perches.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches
> Sent: 11 October 2017 11:21
> On Tue, 2017-10-10 at 14:30 -0500, Gustavo A. R. Silva wrote:
> > In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> > where we are expecting to fall through.
> 
> perhaps use Arnaldo's idea:
> 
> https://lkml.org/lkml/2017/2/9/845
> https://lkml.org/lkml/2017/2/10/485

gah, that is even uglier and requires a chase through
headers to find out what it means.

	David
