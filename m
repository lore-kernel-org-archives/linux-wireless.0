Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3FEPkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 11:40:16 -0400
Message-ID: <1370446810.25710.6.camel@jlt4.sipsolutions.net> (sfid-20130605_174024_641096_047822FB)
Subject: Re: [PATCHv4 2/4] brcm80211: make mgmt_tx in brcmfmac accept a NULL
 channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Antonio Quartulli <ordex@autistici.org>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	brcm80211-dev-list@broadcom.com
Date: Wed, 05 Jun 2013 17:40:10 +0200
In-Reply-To: <51AF5AB7.2070703@broadcom.com>
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
	 <1370444989-2095-2-git-send-email-ordex@autistici.org>
	 <51AF5A92.9050906@broadcom.com> <51AF5AB7.2070703@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-05 at 17:35 +0200, Arend van Spriel wrote:
> On 06/05/2013 05:34 PM, Arend van Spriel wrote:
> > On 06/05/2013 05:09 PM, Antonio Quartulli wrote:
> >> From: Antonio Quartulli <antonio@open-mesh.com>
> >>
> >> cfg80211 passes a NULL channel to mgmt_tx if the frame has
> >> to be sent on the one currently in use by the device.
> >> Make the implementation of mgmt_tx correctly handle this
> >> case
> >>
> >> Cc: Arend van Spriel <arend@broadcom.com>
> >> Cc: brcm80211-dev-list@broadcom.com
> >> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> >> ---
> >
> > For my name above you (or Johannes) can change 'Cc:' to 'Acked-by:'
> 
> Or John?

I think I'll take the whole series if that's ok with everyone, otherwise
we get synchronisation issues between John and myself :)

johannes

