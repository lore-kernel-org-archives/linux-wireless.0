Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:4281 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbYAJR3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 12:29:07 -0500
Received: by fk-out-0910.google.com with SMTP id z23so542971fkz.5
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 09:29:05 -0800 (PST)
To: "Will Dyson" <will.dyson@gmail.com>
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Date: Thu, 10 Jan 2008 18:29:00 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com> <8e6f94720801100352t615025b6j1c2cc0081626fee5@mail.gmail.com>
In-Reply-To: <8e6f94720801100352t615025b6j1c2cc0081626fee5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801101829.00160.IvDoorn@gmail.com> (sfid-20080110_172911_686388_74518C59)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Here is the 2.0.14 release of rt2x00. Again lots of bugfixes,
> > and unfortunately we are still not there yet. I am afraid
> > rt2500usb and rt61pci are lost causes for the 2.6.24 release,
> > they are both broken, and I haven't figured out what is causing
> > this.
> 
> Hi Ivo,
> 
> Sorry to be out of the loop, but what is wrong with rt61pci? It works
> really really well for me, using John's "everything" branch.

My tests indicate rt61pci is currently not working, I just did some regression
testing and it seems the 2.0.14 version is to blame. I still have to run git-bisect
to determine the exact patch that broke it.

Ivo
