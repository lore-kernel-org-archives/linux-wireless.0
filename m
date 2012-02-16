Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51895 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2BPMw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 07:52:58 -0500
Received: by wgbdt10 with SMTP id dt10so1902347wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2012 04:52:57 -0800 (PST)
Message-ID: <1329396752.1852.1.camel@localhost.localdomain> (sfid-20120216_135301_586702_6685D780)
Subject: Re: [iwlwifi 5000] Linux 3.3.0-rc2 drops wifi connection
 (regression from 3.2) - "No buffer space available"
From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 Feb 2012 12:52:32 +0000
In-Reply-To: <20120216114348.GC25833@redhat.com>
References: <1328667237.1747.26.camel@localhost.localdomain>
	 <20120216114348.GC25833@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-16 at 12:43 +0100, Stanislaw Gruszka wrote:
> On Wed, Feb 08, 2012 at 02:13:57AM +0000, Maciej Marcin Piechotka wrote:
> > Hello,
> > 
> > Linux 3.3.0 drops connections from WiFi on 3.3 (worked on 3.2).
> > If I try to ping anything:
> > 
> > ping: sendmsg: No buffer space available
> > 
> > When I disable/enable WiFi by rfkill it works ok. I haven't found what
> > determines the period before it happens.
> 
> What show dmesg?
> 
> Stanislaw

There is no message in dmesg which would correspond to the problem (I
can send the full dump if you would like but there is nothing other then
I had in 3.2.x).

Best regards

