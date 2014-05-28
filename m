Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:52608 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaE1NVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 09:21:11 -0400
Received: by mail-qg0-f53.google.com with SMTP id f51so17442675qge.26
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2014 06:21:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401283040.8146.15.camel@jlt4.sipsolutions.net>
References: <2083629.VLZzpqGjAs@desktop.local> <1401283040.8146.15.camel@jlt4.sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Wed, 28 May 2014 15:20:50 +0200
Message-ID: <CAGnRvuq1By_dZZnv3Vcm+JRxpkyZwv8NfEv4cM-1QChwX-+eqA@mail.gmail.com> (sfid-20140528_152114_073416_81DE23AA)
Subject: Re: [RFC Patch v2] Unify mpp/mesh_path handling for Mac 802.11s
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	Thomas Pedersen <thomas@noack.us>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2014 at 3:17 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Can you not do everything in one patch? :)
>
> Also - I think reporting the MPPs to userspace like the mesh paths is
> probably not a good idea? And I think that happens now since you didn't
> touch the code in cfg?

The current patch ONLY unifies the mpp_path_add() and mesh_path_add()
function. But I could factor out the addition of the atomic counter
for mpp_paths into a patch of its own.

I kept the "exporting mpp" thing for a followup patch, I first wanted
to hear if the whole cleanup is worth the effort.

Henning Rogge
