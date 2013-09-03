Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63558 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3ICRZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 13:25:00 -0400
Received: by mail-ie0-f169.google.com with SMTP id tp5so6270044ieb.14
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 10:25:00 -0700 (PDT)
MIME-Version: 1.0
From: Blaise Gassend <blaise@suitabletech.com>
Date: Tue, 3 Sep 2013 10:24:40 -0700
Message-ID: <CAPvVjiu62Rgt8gFiv5dRyvv3L4EgTZhMaoZgpSx8QBecY3cNSw@mail.gmail.com> (sfid-20130903_192505_463975_19B144EA)
Subject: Hidden SSIDs on DFS channels
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Reposting this as my original post went out without a subject.)

Hi,

Tracking down a customer problem, I recently discovered that Linux
does not currently support hidden SSIDs on DFS channels. As far as I
can tell, there isn't a fundamental reason for this. You could switch
to a frequency, listen for a beacon, once you see the beacon send a
directed probe, and listen for responses. I'm sure there are folks on
this list who have thought about this issue...

- Are there any reasons you know of why my proposed strategy would not
work from a regulatory point of view?

- If a patch were prepared, is this something that would be considered
for mainstream inclusion?

I know that hidden SSIDs are a bad idea. But some customers can be
hard to convince, and dealing with customers who have hidden SSIDs on
DFS channels can be a support burden. If we can make it just work for
them then our life is that much easier.

Regards,
Blaise
