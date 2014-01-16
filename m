Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25935 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaAPMu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 07:50:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: enable firmware STA quick kickout
References: <20140116123336.24551.2629.stgit@potku.adurom.net>
	<CAEFj987MkPQgyTU=K64mXuzCnm7T3SsUOSXiHkAovTVz0_kqwg@mail.gmail.com>
Date: Thu, 16 Jan 2014 14:50:22 +0200
In-Reply-To: <CAEFj987MkPQgyTU=K64mXuzCnm7T3SsUOSXiHkAovTVz0_kqwg@mail.gmail.com>
	(Yeoh Chun-Yeow's message of "Thu, 16 Jan 2014 20:44:43 +0800")
Message-ID: <87ppnst7jl.fsf@kamboji.qca.qualcomm.com> (sfid-20140116_135032_476979_8934E426)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:

> Just would like to know whether the STA is deleted by FW when the FW
> is sending the WMI_PEER_STA_KICKOUT_EVENTID to the host?

AFAICS the firmware just sends the event and assumes that the host
deletes the peer. Luckily in thise case it doesn't seem to do any peer
management on it's own.

-- 
Kalle Valo
