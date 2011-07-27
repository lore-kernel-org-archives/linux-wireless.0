Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50323 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab1G0Uzs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 16:55:48 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QmB8t-0004wD-F6
	for linux-wireless@vger.kernel.org; Wed, 27 Jul 2011 22:55:47 +0200
Received: from qux3.kyla.fi ([82.130.48.19])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2011 22:55:47 +0200
Received: from swaminathanvasanth.r by qux3.kyla.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2011 22:55:47 +0200
To: linux-wireless@vger.kernel.org
From: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Subject: Re: problem on ACS
Date: Wed, 27 Jul 2011 20:55:33 +0000 (UTC)
Message-ID: <loom.20110727T224259-350@post.gmane.org> (sfid-20110727_225551_986510_27F341B9)
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <COL114-W76260EA23039CA8000DB88A320@phx.gbl> <CAB=NE6Wcn3-GwqPJQDXOT0JCNnZgCs1E7HecWrXpc8LS+XRyDA@mail.gmail.com> <201107262031.11394.chunkeey@googlemail.com> <CAB=NE6WoGZfpGnNkdaLdtN+nC+aM1mxV4rkUCMarnuDonQeJeg@mail.gmail.com> <COL114-W2204F3FA55EF4C0D20D0C58A350@phx.gbl> <CAB=NE6WCagRUrMynd2CoAAN_LtoVkaoCYxOLE1COKx9zXgCBuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi all,
 @ MingAnn Ng > If you increase the value for acs_num_req_surveys and
acs_roc_duration_ms, you will not get -inf as the interference value. I faced
this problem initially, but with more number of surveys ACS actually picks the
best channel. 
 @ Luis > I got convincing results on Channel selection. I also cross verified
the selected channel and the channels used by the nearby AP's through Kismet.
With 9 AP's using different channel, ACS selected the channel which was least
used. Great Work Luis ! 



