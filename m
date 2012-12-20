Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2LTOp7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 09:45:59 -0500
Date: Thu, 20 Dec 2012 15:45:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] iwl3945: disable 11a support
Message-ID: <20121220144549.GA10276@redhat.com> (sfid-20121220_154610_840193_B1BF409E)
References: <1356010313-9782-1-git-send-email-sgruszka@redhat.com>
 <1356010313-9782-2-git-send-email-sgruszka@redhat.com>
 <1356010819.10029.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1356010819.10029.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 20, 2012 at 02:40:19PM +0100, Johannes Berg wrote:
> On Thu, 2012-12-20 at 14:31 +0100, Stanislaw Gruszka wrote:
> > I don't believe if there still are users using 11a mode. If they are,
> > they should probably update their network to something that was
> > designed in current century, but I also left module option for them.
> 
> Huh? All of VHT etc. is going to use 5 GHz and will be compatible with
> legacy clients, so having 11a support will allow them to connect to new
> networks? Or am I midunderstanding what you're doing here?

Yes, this disable 5GHz for 3945. I assumed this is not and will not be
used anymore, but seems I was wrong.

BTW: I'm not expect that 11ac AP will work good with 11a, i.e. I'm not
able to connect to mixed network 11a & 11n on my 5GHz AP, but at least
this should be theoretically possible. 

What I'm looking for is possibility to disable 5GHz to avoid network
traffic delays while scanning, but this should be done in cfg80211.

Let's skip this patch.

Thanks
Stanislaw
 

   
