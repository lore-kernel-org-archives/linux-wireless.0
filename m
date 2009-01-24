Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34919 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbZAXWHQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 17:07:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 14:07:16 -0800
Date: Sat, 24 Jan 2009 14:06:37 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Diego E. 'Flameeyes' Petteno`" <flameeyes@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tony Vroon <tony@linx.net>
Subject: [ANN] crda v1.0.1
Message-ID: <20090124220637.GF22475@tesla> (sfid-20090124_230731_640050_27B6DF0B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK -- I've applied your patch and also removed the "v" from the release tarballs.
Also while at it made the wireless-regdb release tarballs use "." instead of "-" for
the version separator as that is what most packaging systems seem to expect. If there
are any issues please let me know. Hopefully this is it :)

  Luis
