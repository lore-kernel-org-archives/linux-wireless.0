Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36715 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbcECTfs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 15:35:48 -0400
Message-ID: <1462304144.10444.13.camel@sipsolutions.net> (sfid-20160503_213552_179626_B103304A)
Subject: Re: dynamic ps + offchannel mgmt_tx + HW RoC
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 03 May 2016 21:35:44 +0200
In-Reply-To: <CALhHN=pxE2+dHxKLvsdWDt7fZ-FwYSUzps6hWB9m7dmZbFytgg@mail.gmail.com> (sfid-20160503_192118_699192_A622BAAC)
References: <CABPxzYLtu53V79O--eDJEdRfn-zw3Wq9Po04F=uFp_FrfJjuiA@mail.gmail.com>
	 <1462281243.2251.2.camel@sipsolutions.net>
	 <CABPxzYJjRMMaUn+zzpzm8Zv8XAn8nfA8FgMTr7bkZve3XWs8ow@mail.gmail.com>
	 <CABPxzYKj-0kaBP6BYQvcTYZtaTTbtc0nR-=69qC9eCDDJoXxaA@mail.gmail.com>
	 <1462291262.2251.4.camel@sipsolutions.net>
	 <CABPxzY+JXre1SzGyqmwYhTw9BB_-PfR02basW0WS34wZKpxK7g@mail.gmail.com>
	 <CALhHN=pxE2+dHxKLvsdWDt7fZ-FwYSUzps6hWB9m7dmZbFytgg@mail.gmail.com>
	 (sfid-20160503_192118_699192_A622BAAC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is, btw, perhaps a different way - just fix the damn stuff.

Requires moving everything into ifmgd rather than local, and then
perhaps if only a single managed interface exists mirroring its state
into the existing driver calls etc.

It'd still be a big task, and I don't see much advantage over just
reimplementing it.

johannes
