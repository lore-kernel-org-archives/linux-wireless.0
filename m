Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:40111 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaE1KnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 06:43:12 -0400
Received: by mail-ve0-f177.google.com with SMTP id db11so12103493veb.22
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2014 03:43:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2083629.VLZzpqGjAs@desktop.local>
References: <2083629.VLZzpqGjAs@desktop.local>
Date: Wed, 28 May 2014 18:43:11 +0800
Message-ID: <CAEFj98755Zfjs_MOXFEF+PPRKH5Q+UVsURmAcf-CKKkVfnrTLA@mail.gmail.com> (sfid-20140528_124315_690310_F65585A0)
Subject: Re: [RFC Patch v2] Unify mpp/mesh_path handling for Mac 802.11s
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Pedersen <thomas@noack.us>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> While looking through the code I noticed that there seems to be no code-path
> that removes stall mpp_path entries (except for the removal of the mesh
> interface) ! Unless I overlooked something this would be a way to use up all
> existing memory of the kernel by sending it 802.11s packets with changing
> proxied addresses.

AFAIK, we don't really "manage" the mpp path and relying on incoming
packet to update the mpp path table.

----
Chun-Yeow
