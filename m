Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:62637 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaE1LxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 07:53:17 -0400
Received: by mail-qg0-f50.google.com with SMTP id z60so17427416qgd.9
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2014 04:53:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj984PE5L2Yv4r6nshAy6Zuama5wsins27xeX9A1B4RGqmgg@mail.gmail.com>
References: <2083629.VLZzpqGjAs@desktop.local> <CAEFj98755Zfjs_MOXFEF+PPRKH5Q+UVsURmAcf-CKKkVfnrTLA@mail.gmail.com>
 <CAGnRvuq=aLFhFuE=ntJ1GkFFf_UNQjDxx2KcGMdskRycunZbaA@mail.gmail.com> <CAEFj984PE5L2Yv4r6nshAy6Zuama5wsins27xeX9A1B4RGqmgg@mail.gmail.com>
From: Henning Rogge <hrogge@gmail.com>
Date: Wed, 28 May 2014 13:52:57 +0200
Message-ID: <CAGnRvuoXq-1Ehg7tAiO9uZAhp0NJkp3T_xU-4yG9+H7g_NvY+g@mail.gmail.com> (sfid-20140528_135321_194773_F351A118)
Subject: Re: [RFC Patch v2] Unify mpp/mesh_path handling for Mac 802.11s
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@noack.us>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2014 at 1:44 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Agree. Maybe a timer to delete the expired mpp table and just let the
> incoming received packet to reinsert the table?

I will prepare a second cleanup patch for the 802.11s code.

Henning Rogge
