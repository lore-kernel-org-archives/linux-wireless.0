Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44889 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZEZNsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 09:48:45 -0400
Subject: Re: [PATCH v11] rfkill: rewrite
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Will Keaney <keaneyw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243344763.2575.3.camel@localhost.localdomain>
References: <1242942720.4212.19.camel@johannes.local>
	 <1243068246.4606.45.camel@johannes.local> <4A1BDE51.7020009@gmail.com>
	 <20090526131533.GA3932@tuxdriver.com>
	 <1243344763.2575.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 26 May 2009 15:48:27 +0200
Message-Id: <1243345707.20399.0.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> > > > This patch completely rewrites the rfkill core to address
> > > > the following deficiencies:
> > > >   
> > > I applied this to a fresh pull of wireless-testing this morning, and
> > > haven't had any problems from it.  It looks like the soft lockup I
> > > reported earlier has been fixed.
> > 
> > Cool, thanks for the report.
> > 
> > I'm leaning towards merging this in time for the 2.6.31 merge
> > window...who wants to complain? :-)
> 
> Merge it!

yeah, go for it ;)

Regards

Marcel


