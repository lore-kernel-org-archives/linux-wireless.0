Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa012-1msr.fastwebnet.it ([62.101.93.132]:60905 "EHLO
	aa012-1msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab1FDQ66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 12:58:58 -0400
Message-ID: <4DEA644D.3030109@absence.it> (sfid-20110604_185915_088132_0ACE7EC3)
Date: Sat, 04 Jun 2011 18:58:53 +0200
From: Marco Chiappero <marco@absence.it>
MIME-Version: 1.0
To: Mattia Dongili <malattia@linux.it>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 12/25] sony-laptop: input core improvements improvements
References: <4DE8FC4A.9010401@absence.it> <4DE9012E.5040207@absence.it> <20110604080717.GC7194@kamineko.org> <4DEA4D67.8000009@absence.it> <20110604164021.GA12552@kamineko.org>
In-Reply-To: <20110604164021.GA12552@kamineko.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il 04/06/2011 18:40, Mattia Dongili ha scritto:
> sure it's possible but it's going to be a source of headache once sony
> changes their keyboard layout again (and it will happen).

Well, it depends on when, if it will happen in 2020 that's absolutely 
fine. ;)

> Using generic key codes and remapping them in userspace where necessary
> worked for more than 10 years and is still working fine.

Sure and I consider to be a good alternative, but it looks to me like 
being another workaround, it is fine for particular exceptions that need 
a few remappings, but it should not be the rule, the driver extension. 
That's why I was asking about this change.
