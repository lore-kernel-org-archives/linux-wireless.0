Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:18352 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760586AbXGaPC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 11:02:58 -0400
Received: by fk-out-0910.google.com with SMTP id z23so427147fkz
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 08:02:56 -0700 (PDT)
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
Date: Tue, 31 Jul 2007 17:06:51 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <20070731115446.5717.37617.stgit@localhost> <46AF4889.4070902@warmcat.com> <200707311650.34795.IvDoorn@gmail.com>
In-Reply-To: <200707311650.34795.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707311706.52073.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > > Which version are you using?
> > > wireless-dev <---
> > > rt2x00.git
> > > rt2x00 cvs
> 
> Ok, rt2x00.git contains many changes to the initialization of the device,
> so it is a bit hard to compare at the moment. At least it is confirmed that rt2x00 can
> receive all frames in monitor mode and the problem area is the DROP filter.
> 
> I'll release rt2x00 2.0.5 later today with all those changes, including the rxdone rate
> selection fix. So if you could retest later to see if the problem disappeared in 2.0.5 it
> would be great. :)

Ok, that was easier then I thought, rt2x00 2.0.5 _will_ contain the fix for this.
I just noticed that when the first and only interface is a monitor interface
the device was not being configured at all. This has now been fixed in rt2x00.git,
so it will be part of the 2.0.5 release later today. :)

Ivo



