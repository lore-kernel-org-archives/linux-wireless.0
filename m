Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47764 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2LEJR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 04:17:56 -0500
Message-ID: <1354699100.9972.8.camel@jlt4.sipsolutions.net> (sfid-20121205_101800_297767_4BFD02DF)
Subject: Re: [PATCH] mac80211: Moving Zero Len subframe reporting under
 driver capability check.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 05 Dec 2012 10:18:20 +0100
In-Reply-To: <CABPxzYKEG5053YpLxbTf-ijn1-aLunmnrsvR8w+nCL86XCmOKQ@mail.gmail.com> (sfid-20121205_101040_012178_916FCA9F)
References: <CABPxzYKvtgdoxU-dFS2F0tz_1F6cz02uvVgy5qfMPCEbLOZZ=A@mail.gmail.com>
	 <1354698297.9972.4.camel@jlt4.sipsolutions.net>
	 <1354698356.9972.5.camel@jlt4.sipsolutions.net>
	 <CABPxzYKEG5053YpLxbTf-ijn1-aLunmnrsvR8w+nCL86XCmOKQ@mail.gmail.com>
	 (sfid-20121205_101040_012178_916FCA9F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 14:40 +0530, Krishna Chaitanya wrote:
> Agree. this is just a check to avoid buggy drivers misusing the field :-)

Fair enough, if you resend a patch that applies I'll do it.

johannes

