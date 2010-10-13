Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52072 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0JMLGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 07:06:20 -0400
Subject: Re: Firmware versioning best practices: ath3k-2.fw rename or
 replace ath3k-1.fw ?
From: Marcel Holtmann <marcel@holtmann.org>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Suraj Sumangala <Suraj.Sumangala@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20101012211726.GE2678@broadcom.com>
References: <20101008170258.GJ10149@tux> <4CAF5488.3030706@Atheros.com>
	 <20101008181508.GM10149@tux>  <20101012211726.GE2678@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 13:06:10 +0300
Message-ID: <1286964370.3316.6.camel@aeonflux>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henry,

> > > Marcel had answered me before. It makes sense to have same file name.
> > > Other ways we end up changing the driver whenever there is a firmware 
> > > change.
> > 
> > > > I last tried to document a thread we had over this here:
> > > >
> > > > http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
> > > >
> > 
> > Thanks, I've updated that link above to document bug fixing does not require
> > a filename change.
> 
> I don't really understand why you would not want to change the code revision
> part of the filename.  
> 
> I totally agree that you don't want to change the driver every time the
> firmware gets a bug fix, but wasn't that the whole point of splitting the name
> into API and code revisions portions, and symlinking the file to one that just
> has the API version?
> 
> What's the issue with using the process as originally documented?

as I stated before, for Bluetooth this makes no sense. You don't need
API version numbers since the API is a STANDARD. It is called HCI. So
please don't use API version numbers in the firmware files.

I will reject firmware file versions for upstream drivers.

Regards

Marcel


