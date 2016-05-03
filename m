Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36166 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933831AbcECRmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 13:42:14 -0400
Message-ID: <1462297330.2251.5.camel@sipsolutions.net> (sfid-20160503_194220_922802_871A4426)
Subject: Re: dynamic ps + offchannel mgmt_tx + HW RoC
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 03 May 2016 19:42:10 +0200
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

On Tue, 2016-05-03 at 19:21 +0200, Janusz Dziedzic wrote:
> 
> Why not remove PS code from the mac80211 then, while is broken and
> should not be used?
> 

It'd still be a regression since some drivers can kinda use it.

johannes
