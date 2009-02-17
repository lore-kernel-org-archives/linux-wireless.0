Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40713 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZBQUYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 15:24:44 -0500
Subject: Re: Missing link quality with wireless-testing
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1234899806.29785.35.camel@johannes.local>
References: <1234896777.4678.7.camel@californication>
	 (sfid-20090217_195251_321967_5E2E0AB8)  <1234899806.29785.35.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 21:24:54 +0100
Message-Id: <1234902294.4678.12.camel@californication> (sfid-20090217_212448_487684_EFD6984E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > I have been running the wireless-testing kernel from yesterday and I
> > realized that something with the link quality values from scanning
> > results is broken.
> 
> What exactly is broken by this? Wext never guaranteed that 'qual' values
> be present, and thus any application that breaks from not having 'qual'
> is broken anyway.

that be it, but I would still consider this a regression. Since when do
we just start removing API details without any proper warning or grace
period?

Regards

Marcel


