Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:46217 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab1DAQAx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 12:00:53 -0400
Subject: Re: ChipCommon as independent driver?
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikGp+ZFhTtsaW7E4SO_5trte1_eF4KLWbkwVty5@mail.gmail.com> (sfid-20110401_104947_004628_8A7D9C8C)
References: <AANLkTikGp+ZFhTtsaW7E4SO_5trte1_eF4KLWbkwVty5@mail.gmail.com>
	 (sfid-20110401_104947_004628_8A7D9C8C)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 18:00:46 +0200
Message-ID: <1301673646.5219.18.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 16:49 +0200, Rafał Miłecki wrote: 
> Do you have idea how we could nicely solve that issue?

Yeah. Just don't share code between ssb and bcmai.
That's the only clean solution to that mess.

-- 
Greetings Michael.

