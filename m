Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55726
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965412AbXBOJyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 04:54:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: nl80211 userspace
Date: Thu, 15 Feb 2007 10:54:21 +0100
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1171479846.3709.3.camel@johannes.berg> <40f31dec0702150017x3ecfca57ucded8f1d88bbb121@mail.gmail.com>
In-Reply-To: <40f31dec0702150017x3ecfca57ucded8f1d88bbb121@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200702151054.21799.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 February 2007 09:17, Nick Kossifidis wrote:
> I think it would be nice to have ifconfig for all interface
> configuration as they have done in openbsd, it's better to have one
> tool for all. What do you think ?

Well, I think it's better to have a seperate tool, but I guess
that's only a matter of taste if we want to have it seperate
or included into some existing program.

But, I think python is not quite the best programming language
for this, as we don't want to install python on small embedded systems.

-- 
Greetings Michael.
