Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52260 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab1FEWYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 18:24:07 -0400
Date: Mon, 6 Jun 2011 07:24:03 +0900
From: Mattia Dongili <malattia@linux.it>
To: Marco Chiappero <marco@absence.it>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 12/25] sony-laptop: input core improvements improvements
Message-ID: <20110605222401.GA26835@kamineko.org> (sfid-20110606_002415_855468_738559BD)
References: <4DE8FC4A.9010401@absence.it>
 <4DE9012E.5040207@absence.it>
 <20110604080717.GC7194@kamineko.org>
 <4DEA4D67.8000009@absence.it>
 <20110604164021.GA12552@kamineko.org>
 <4DEA644D.3030109@absence.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DEA644D.3030109@absence.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 04, 2011 at 06:58:53PM +0200, Marco Chiappero wrote:
> Il 04/06/2011 18:40, Mattia Dongili ha scritto:
...
> >Using generic key codes and remapping them in userspace where necessary
> >worked for more than 10 years and is still working fine.
> 
> Sure and I consider to be a good alternative, but it looks to me
> like being another workaround, it is fine for particular exceptions
> that need a few remappings, but it should not be the rule, the
> driver extension. That's why I was asking about this change.

what is a better solution? having keymaps for every different layout
that Sony implemented throught the years and adding more when things
change? This already exists in userspace, it makes not much sense to
have it in the kernel as well.

-- 
mattia
:wq!
