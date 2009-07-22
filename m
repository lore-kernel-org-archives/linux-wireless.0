Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emita2.mittwald.de ([85.199.173.189]:54951 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbZGVJCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 05:02:24 -0400
Received: from mx51.mymxserver.com (mail5103.mittwald.de [172.16.51.3])
	by emita2.mittwald.de (Postfix) with ESMTP id A52CD5FD0B1
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 10:54:49 +0200 (CEST)
From: Holger Schurig <h.schurig@mn-solutions.de>
To: "Lars Ericsson" <Lars_Ericsson@telia.com>
Subject: Re: Slow roaming in mac80211 (2.6.30).
Date: Wed, 22 Jul 2009 10:55:48 +0200
Cc: "'Johannes Berg'" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, hostap@shmoo.com
References: <1B3FCF72EBBC44A39F5A80B8FFBF6402@gotws1589>
In-Reply-To: <1B3FCF72EBBC44A39F5A80B8FFBF6402@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907221055.48791.h.schurig@mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> For .26 I have made a few patches to fix minor issues related
> to roaming.

It might be worthwile for you to publish this code, even it it's 
for an ancient kernel. You can post that to the mailing list and 
mark them as "RFC" instead of "PATCH" in the subject line.

Some people are currently working on roaming support, e.g. 
Helmut. Your patches/findings might give some input or ideas.

