Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:48756 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbaA1VdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 16:33:09 -0500
MIME-Version: 1.0
Date: Tue, 28 Jan 2014 13:33:07 -0800
Message-ID: <CACUGKYOT3sSveRZ6-JjMX-ZGHjyVjmJ2ZnYQXLzFj11J6mbypQ@mail.gmail.com> (sfid-20140128_223313_257820_A5FB381A)
Subject: Marvell Driver for SD8797
From: John Tobias <john.tobias.ph@gmail.com>
To: linux-wireless@vger.kernel.org,
	"<linux-arm-kernel@lists.infradead.org>"
	<linux-arm-kernel@lists.infradead.org>,
	"<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Cc: sebastian.hesselbarth@gmail.com, frankh@marvell.com,
	Bing Zhao <bzhao@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

Does anyone using the Marvell SD8797 here?. I tested both the
opensource and the proprietary driver of Marvell for suspend mode (S3)
on iMX6SL board running 3.13 kernel.

In opensource, the driver were able to suspend/resume and able to keep
the IP address and SSID as well, which is good.

In proprietary driver, the driver were able to suspend/resume and able
to keep the IP address but, not the SSID.

Any idea?.


Regards,

john
