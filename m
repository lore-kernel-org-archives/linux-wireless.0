Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:35329 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbYLDFK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 00:10:56 -0500
Message-ID: <4937665E.4010402@lwfinger.net> (sfid-20081204_061102_590790_1B6CAAC0)
Date: Wed, 03 Dec 2008 23:10:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: =?ISO-8859-1?Q?Mart=EDn_Ernesto_Barreyro?=
	<barreyromartin@gmail.com>
Subject: Help with a wireshark dump
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RTL8187 and RTL8187B drivers hang under unknown circumstances. Noth=
ing is
logged. The only hint is that it seems to be aggravated by running a to=
rrent.
Thanks to Mart=EDn Ernesto Barreyro who captured a failure, I have a du=
mp of
roughly 3000 packets with the failure somewhere in the middle. Unfortun=
ately, I
have no idea what has happened. Is there someone willing to look at the=
se data?

Thanks,

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
