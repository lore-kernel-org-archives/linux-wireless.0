Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45629 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3FFNPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 09:15:14 -0400
Date: Wed, 5 Jun 2013 13:47:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	Antonio Quartulli <ordex@autistici.org>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCHv4 2/4] brcm80211: make mgmt_tx in brcmfmac accept a NULL
 channel
Message-ID: <20130605174711.GB15004@tuxdriver.com> (sfid-20130606_151519_998193_41EDCE2D)
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
 <1370444989-2095-2-git-send-email-ordex@autistici.org>
 <51AF5A92.9050906@broadcom.com>
 <51AF5AB7.2070703@broadcom.com>
 <1370446810.25710.6.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370446810.25710.6.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 05, 2013 at 05:40:10PM +0200, Johannes Berg wrote:
> On Wed, 2013-06-05 at 17:35 +0200, Arend van Spriel wrote:
> > On 06/05/2013 05:34 PM, Arend van Spriel wrote:
> > > On 06/05/2013 05:09 PM, Antonio Quartulli wrote:
> > >> From: Antonio Quartulli <antonio@open-mesh.com>
> > >>
> > >> cfg80211 passes a NULL channel to mgmt_tx if the frame has
> > >> to be sent on the one currently in use by the device.
> > >> Make the implementation of mgmt_tx correctly handle this
> > >> case
> > >>
> > >> Cc: Arend van Spriel <arend@broadcom.com>
> > >> Cc: brcm80211-dev-list@broadcom.com
> > >> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> > >> ---
> > >
> > > For my name above you (or Johannes) can change 'Cc:' to 'Acked-by:'
> > 
> > Or John?
> 
> I think I'll take the whole series if that's ok with everyone, otherwise
> we get synchronisation issues between John and myself :)

Yes, please.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
