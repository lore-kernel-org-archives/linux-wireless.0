Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37731 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbaE1N1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 09:27:50 -0400
Message-ID: <1401283656.8146.17.camel@jlt4.sipsolutions.net> (sfid-20140528_152753_836225_CF78D711)
Subject: Re: [RFC Patch v2] Unify mpp/mesh_path handling for Mac 802.11s
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	Thomas Pedersen <thomas@noack.us>
Date: Wed, 28 May 2014 15:27:36 +0200
In-Reply-To: <CAGnRvuq1By_dZZnv3Vcm+JRxpkyZwv8NfEv4cM-1QChwX-+eqA@mail.gmail.com> (sfid-20140528_152112_142547_62B180BF)
References: <2083629.VLZzpqGjAs@desktop.local>
	 <1401283040.8146.15.camel@jlt4.sipsolutions.net>
	 <CAGnRvuq1By_dZZnv3Vcm+JRxpkyZwv8NfEv4cM-1QChwX-+eqA@mail.gmail.com>
	 (sfid-20140528_152112_142547_62B180BF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-28 at 15:20 +0200, Henning Rogge wrote:
> On Wed, May 28, 2014 at 3:17 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Can you not do everything in one patch? :)
> >
> > Also - I think reporting the MPPs to userspace like the mesh paths is
> > probably not a good idea? And I think that happens now since you didn't
> > touch the code in cfg?
> 
> The current patch ONLY unifies the mpp_path_add() and mesh_path_add()
> function. But I could factor out the addition of the atomic counter
> for mpp_paths into a patch of its own.

Please.

> I kept the "exporting mpp" thing for a followup patch, I first wanted
> to hear if the whole cleanup is worth the effort.

Ok. Also, please read CodingStyle.

johannes

