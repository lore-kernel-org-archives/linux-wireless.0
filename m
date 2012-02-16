Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2BPNKM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 08:10:12 -0500
Date: Thu, 16 Feb 2012 14:10:10 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [iwlwifi 5000] Linux 3.3.0-rc2 drops wifi connection (regression
 from 3.2) - "No buffer space available"
Message-ID: <20120216131009.GH25833@redhat.com> (sfid-20120216_141017_305134_4F597140)
References: <1328667237.1747.26.camel@localhost.localdomain>
 <20120216114348.GC25833@redhat.com>
 <1329396752.1852.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1329396752.1852.1.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 16, 2012 at 12:52:32PM +0000, Maciej Marcin Piechotka wrote:
> On Thu, 2012-02-16 at 12:43 +0100, Stanislaw Gruszka wrote:
> > On Wed, Feb 08, 2012 at 02:13:57AM +0000, Maciej Marcin Piechotka wrote:
> > > Hello,
> > > 
> > > Linux 3.3.0 drops connections from WiFi on 3.3 (worked on 3.2).
> > > If I try to ping anything:
> > > 
> > > ping: sendmsg: No buffer space available
> > > 
> > > When I disable/enable WiFi by rfkill it works ok. I haven't found what
> > > determines the period before it happens.
> > 
> > What show dmesg?
> > 
> > Stanislaw
> 
> There is no message in dmesg which would correspond to the problem (I
> can send the full dump if you would like but there is nothing other then
> I had in 3.2.x).

So it does not look like iwlwifi issue. When this happen what shows
"strace ping" ?

Stanislaw
