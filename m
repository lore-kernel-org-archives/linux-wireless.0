Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:54205 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbcABLWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 06:22:08 -0500
Subject: Re: net-libertas: Better exception handling in
 if_spi_host_to_card_worker()
To: Arend van Spriel <aspriel@gmail.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686F0B2.5000000@users.sourceforge.net>
 <56870866.7020000@cogentembedded.com>
 <568785B3.5000905@users.sourceforge.net>
 <alpine.DEB.2.02.1601020914100.2063@localhost6.localdomain6>
 <5687939E.7010701@users.sourceforge.net> <5687A2C7.3000704@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5687B2BC.8090901@users.sourceforge.net> (sfid-20160102_122230_402491_77B8D491)
Date: Sat, 2 Jan 2016 12:21:32 +0100
MIME-Version: 1.0
In-Reply-To: <5687A2C7.3000704@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I have never seen much evolution going on in this area.

I can get an other impression from a specific document for example.
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/log/Documentation/CodingStyle


> What the patch tries to do is avoid the extra 'if (err)'.

Yes. - I propose to look at related consequences together with the usage
of a popular short jump label once more.


> Setting coding style aside, the question is whether there is
> a good metric for the patch.

A software development challenge is to accept changes also around a topic
like "error handling". My update suggestion for the source file
"drivers/net/wireless/marvell/libertas/if_spi.c" should only improve
exception handling. (I came along other source files where more improvements
will eventually be possible.)

When will the run-time behaviour matter also for exceptional situations?


> Did you look at the resulting assembly code for different target architectures?

Not yet. - Which execution system variants would you recommend for
further comparisons?

Regards,
Markus
