Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53355 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab1EBISR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 04:18:17 -0400
Received: by eya28 with SMTP id 28so1690427eya.7
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2011 01:18:15 -0700 (PDT)
Subject: Re: [PATCH 01/10] wl12xx: add BT-coexistance for AP
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1304111826.12586.203.camel@cumari>
References: <1303125329-27214-1-git-send-email-arik@wizery.com>
	 <1304107365.12586.157.camel@cumari>  <1304111826.12586.203.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 11:18:10 +0300
Message-ID: <1304324290.12586.217.camel@cumari> (sfid-20110502_101824_730556_0DEA9E6E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-04-30 at 00:17 +0300, Luciano Coelho wrote:
> On Fri, 2011-04-29 at 23:02 +0300, Luciano Coelho wrote:
> > On Mon, 2011-04-18 at 14:15 +0300, Arik Nemtsov wrote:
> > > Initialize AP specific BT coexitance parameters to default values and
> > > enable them in AP mode.
> > > 
> > > Signed-off-by: Arik Nemtsov <arik@wizery.com>
> > > ---
> > 
> > Applied the whole series, thanks Arik!
> 
> Ooops, these didn't go in yet.  There were some conflicts and I have
> mistakenly kept them out.  I'll merge them and add them soon.

Okay, now this patchset has been applied and pushed.  I had to reset the
master and wl12xx-next branches.  I'll send a separate email telling
about that.

-- 
Cheers,
Luca.

