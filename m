Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:55981 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbZCKTEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 15:04:25 -0400
Received: from localhost ([127.0.0.1] helo=www.phantomjinx.co.uk)
	by vilya.visn.co.uk with esmtpa (Exim 4.69)
	(envelope-from <p.g.richardson@phantomjinx.co.uk>)
	id 1LhTj5-0002UI-Ma
	for linux-wireless@vger.kernel.org; Wed, 11 Mar 2009 19:04:23 +0000
Message-ID: <50533.82.152.175.172.1236798263.squirrel@www.phantomjinx.co.uk> (sfid-20090311_200439_226007_15F8697E)
Date: Wed, 11 Mar 2009 19:04:23 -0000 (UTC)
Subject: rtl8187 - nice work!
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Installed the compat-wireless-2009-03-10 and the speed has greatly
improved. Thanks very much.

I do have some observations that might be a bug or just configuration.

When powering up, the wireless decided on 54M as its bit rate.
Consequently, tcp was patchy at best - losing packets whilst pinging, s=
sh
failing to connect. Setting the rate back to a fixed 11M solves this an=
d
gives good speed. Interestingly, performance declines as I up the bit r=
ate
from 11 to 18 etc...

Of course, simple specifying the RATE in the ifcfg-wlan0 as 11M sorts t=
his
perfectly.

Anyway, thanks and regards

PGR

--=20
Laws are partly formed for the sake of good men, in order to instruct t=
hem
how they may live on friendly terms with one another, and partly for th=
e
sake of those who refuse to be instructed, whose spirit cannot be subdu=
ed,
or softened, or hindered from plunging into evil. [The Laws, Plato]

You fiend! Never have I encountered such corrupt and foul-minded
perversity=85 Have you ever considered a career in the church?
Bishop of Bath and Wells (Blackadder II)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
