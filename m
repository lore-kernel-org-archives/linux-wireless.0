Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52898 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab0JaDbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 23:31:16 -0400
Received: by ywc21 with SMTP id 21so273430ywc.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 20:31:15 -0700 (PDT)
Message-ID: <4CCCE31A.5030608@lwfinger.net>
Date: Sat, 30 Oct 2010 22:31:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Deauthentication for reason 6 using Intel 5300 in 2.6.34
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A user on the openSUSE forum reports that the connection drops frequently when
using 802.11n on a 5300 with a 2.6.34 kernel. It is deauthenticated for reason
6. He was able to stabilize the connection by disabling N mode. I think he used
"options iwlagn 11n_disable=1 11n_disable50=1".

Is this a known problem? Would the situation be improved by using
compat-wireless? If so, is "bleeding-edge" needed?

Thanks,

Larry
