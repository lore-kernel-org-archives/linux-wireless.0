Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:47652 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYKZOxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 09:53:55 -0500
Received: by qw-out-2122.google.com with SMTP id 3so123920qwe.37
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 06:53:54 -0800 (PST)
Message-ID: <69e28c910811260653mdb6b96ej97d7f6bee30313b0@mail.gmail.com> (sfid-20081126_155401_243833_161933D7)
Date: Wed, 26 Nov 2008 15:53:54 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: iw needs a permalink on http://wireless.kernel.org/download/iw/
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Corrently, different versions of iw can be downloaded from
http://wireless.kernel.org/download/iw/, with the latest being 0.9.6,
but there is no link that automatically takes users to the latest
version (e.g. http://wireless.kernel.org/download/iw/iw-latest.tar.bz2
always redirecting to the most recent release). This prevents me from
automatically linking to the latest release of iw, so I can only link
to one specific fixed release.

I am in favor of creating a symlink at
http://wireless.kernel.org/download/iw/iw-latest.tar.bz2.

Ideas?

Thanks,
G=E1bor Stefanik

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
