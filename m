Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:43831 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab2BHHAH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 02:00:07 -0500
Message-ID: <4F321CDA.7020607@01019freenet.de> (sfid-20120208_080031_815353_2D28D722)
Date: Wed, 08 Feb 2012 07:57:30 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: trencan@centrum.cz
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: connection interrupted for rt61pci in master mode
References: <20120128154544.70E060CD@centrum.cz>, <4F30BEED.4010905@01019freenet.de>, <20120207071444.8C823024@centrum.cz> <4F30D3EE.2010501@01019freenet.de> <20120207214801.21BCB62B@centrum.cz>
In-Reply-To: <20120207214801.21BCB62B@centrum.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Michal,

trencan@centrum.cz schrieb:
> 
> I tried maxcpus=0 and verified that really only one cpu core is used
> but didn't help (so not smp problem).

Thank you for examining! At least a smp related problem should be
eliminated now!


Kind regards,
Andreas
