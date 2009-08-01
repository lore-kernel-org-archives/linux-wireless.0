Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47162 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752208AbZHAKj5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 06:39:57 -0400
Message-ID: <4A741B7B.7070200@gmx.de>
Date: Sat, 01 Aug 2009 12:39:55 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Pavel Roskin <proski@gnu.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] compat-2.6: Makefile: fixed test expressions for target
 	install
References: <4A720FE4.4020301@gmx.de> <1248990136.10154.10.camel@mj> 	<4A733CDE.4060801@gmx.de> <1249066564.20276.3.camel@mj> <4A737AFC.40301@gmx.de> <43e72e890907311622u1059be72y7c833f888b11cf56@mail.gmail.com>
In-Reply-To: <43e72e890907311622u1059be72y7c833f888b11cf56@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2009 01:22 AM, Luis R. Rodriguez wrote:
> Actually please do keep relying on /bin/bash, all the scripts on
> compat-wireless do depend on /bin/bash, I don't expect users of
> dash/etc to use compat-wireless.
> 
> If we want to make compat-wireless be shell agnostic we'd need to
> address all the other scripts. I rather not deal with that now unless
> we really think that is also a good idea and someone is up for the
> task.

IMHO we could make bug fixes to the Makefile/scripts shell agnostic if it's not much effort and
doesn't break readability, which is neither the case here.

Regards,
Joerg.
