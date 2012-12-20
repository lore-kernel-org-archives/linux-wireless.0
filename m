Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab2LTP0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 10:26:10 -0500
Message-ID: <1356017187.10029.18.camel@jlt4.sipsolutions.net> (sfid-20121220_162614_558432_553D2DAF)
Subject: Re: [PATCH 2/3] iwl3945: disable 11a support
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 20 Dec 2012 16:26:27 +0100
In-Reply-To: <20121220144549.GA10276@redhat.com>
References: <1356010313-9782-1-git-send-email-sgruszka@redhat.com>
	 <1356010313-9782-2-git-send-email-sgruszka@redhat.com>
	 <1356010819.10029.15.camel@jlt4.sipsolutions.net>
	 <20121220144549.GA10276@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-20 at 15:45 +0100, Stanislaw Gruszka wrote:
> On Thu, Dec 20, 2012 at 02:40:19PM +0100, Johannes Berg wrote:
> > On Thu, 2012-12-20 at 14:31 +0100, Stanislaw Gruszka wrote:
> > > I don't believe if there still are users using 11a mode. If they are,
> > > they should probably update their network to something that was
> > > designed in current century, but I also left module option for them.
> > 
> > Huh? All of VHT etc. is going to use 5 GHz and will be compatible with
> > legacy clients, so having 11a support will allow them to connect to new
> > networks? Or am I midunderstanding what you're doing here?
> 
> Yes, this disable 5GHz for 3945. I assumed this is not and will not be
> used anymore, but seems I was wrong.
> 
> BTW: I'm not expect that 11ac AP will work good with 11a, i.e. I'm not
> able to connect to mixed network 11a & 11n on my 5GHz AP, but at least
> this should be theoretically possible. 
> 
> What I'm looking for is possibility to disable 5GHz to avoid network
> traffic delays while scanning, but this should be done in cfg80211.

Sounds more like a policy decision in wpa_s?

johannes

