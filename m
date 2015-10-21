Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53954 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbbJUM0M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 08:26:12 -0400
Message-ID: <1445430370.4558.34.camel@sipsolutions.net> (sfid-20151021_142616_249998_EA83F172)
Subject: Re: [PATCH] iw: remove superfluous includes
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Wed, 21 Oct 2015 14:26:10 +0200
In-Reply-To: <1445429077-21719-1-git-send-email-ola1olsson@gmail.com> (sfid-20151021_140456_940560_96CE6470)
References: <1445429077-21719-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151021_140456_940560_96CE6470)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm always a bit scared of patches like this in case we just start
relying on an include file including something else, but I'll apply it
and we'll see what happens :)

johannes
