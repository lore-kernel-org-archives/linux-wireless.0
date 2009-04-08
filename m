Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([207.115.11.51]:59943 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763768AbZDHPiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 11:38:24 -0400
Message-ID: <49DCC4E0.4060703@lwfinger.net> (sfid-20090408_173839_769216_5A0196C6)
Date: Wed, 08 Apr 2009 10:38:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] p54: generate channel list dynamically
References: <200904081320.49607.chunkeey@web.de>
In-Reply-To: <200904081320.49607.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> I'm thinking of splitting up p54common.c into small files...
> e.g: one file each for eeprom, mac, led and main/lib code.
> So I'm asking for your opinion "before" I waste time with it.

Christian,

With this patch applied, p54common.c is 77K characters, which is on the edge of
being unwieldy. I would not object to splitting it into the 4 categories you
mention.

As we are roughly 2 months from the 2.6.31 merge, this might be a good time to
do it as there would be plenty of time for testing.

I have not yet tested this patch as I'm currently chasing a regression in
2.6.30-rc1 from Linus's tree. Once that is squared away, then I'll test the
channel list changes. I do approve of the concept.

Larry


