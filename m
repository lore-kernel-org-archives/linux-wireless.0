Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:62882 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160AbZAMX7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 18:59:49 -0500
Message-ID: <496D2AE4.7000808@lwfinger.net> (sfid-20090114_005957_740853_8987481F)
Date: Tue, 13 Jan 2009 17:59:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Warning in latest wireless-testing
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the latest pull from wireless testing, I get the following warning:

  CC [M]  drivers/net/wireless/b43/main.o
drivers/net/wireless/b43/main.c: In function =E2=80=98b43_op_set_key=E2=
=80=99:
drivers/net/wireless/b43/main.c:3636: warning: pointer type mismatch
in conditional expression

Larry

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
