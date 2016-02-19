Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out04.msg.oleane.net ([62.161.7.2]:39168 "EHLO
	smtp-out04.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1427781AbcBSQ7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 11:59:40 -0500
Received: from smtp08.msg.oleane.net (smtp08.mail.priv [172.17.20.117])
	by smtp-out04.msg.oleane.net with ESMTP id u1JGxJZD014428
	for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2016 17:59:37 +0100
From: =?UTF-8?Q?C=C3=A9dric_Debarge_-_ACKSYS?= <cedric.debarge@acksys.fr>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	"'Ben Greear'" <greearb@candelatech.com>
References: <cover.1454685673.git.cedric.debarge@acksys.fr> <1455827262.2084.31.camel@sipsolutions.net>
In-Reply-To: <1455827262.2084.31.camel@sipsolutions.net>
Subject: RE: [RFC 0/2] mac80211: add support for ht_caps mcs rxmask override
Date: Fri, 19 Feb 2016 17:39:14 +0100
Message-ID: <01a201d16b34$11dcf5e0$3596e1a0$@acksys.fr> (sfid-20160219_175952_197346_C3058C8B)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> What are you working on that you need this?

We are working on critical industrial networks where a specific (generally high) bandwidth is required.
Supressing low MCSs (that are not able to handle the desired bandwidth) allows us to be sure that the wireless link can sustain the requested bandwidth.
If the radio conditions do not allow high enough MCSs, we prefer increase the AP density rather than not being able to communicate at the requested speed.
 
> I think my comments to him apply to this too - see the thread at
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/143789

Thanks for the link, I didn't noticed Ben Grear's request.
According to the given patches, it seems the targeted goal is quite similar. So your comments also apply on my demand.

Anyway, thanks for your answer.

Cedric

