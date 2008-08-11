Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:47133 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbYHKV4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 17:56:41 -0400
Message-ID: <48A0B599.6020804@lwfinger.net> (sfid-20080811_235644_839470_E22A5D57)
Date: Mon, 11 Aug 2008 16:56:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?matthieu_Barth=E9lemy?= <bonsouere@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Add USB ID for Netgear WG111V3
References: <489fbfb9.IY+WzjnFwKATbnw0%Larry.Finger@lwfinger.net> <22bd28110808111436j7ba8a396h77cbc20f88337029@mail.gmail.com>
In-Reply-To: <22bd28110808111436j7ba8a396h77cbc20f88337029@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

matthieu Barth=E9lemy wrote:
> Thanks for your willingness to merge this patch. From what I know,
> this device is very common so a lot of new users will potentially
> benefit from the rtl8187B code.
> Any news about a possible inclusion in 2.6.27?

That decision will rest with John Linville. At this stage, only bug=20
fixes are supposed to be sent to 2.6.27. New features, such as adding=20
a new device ID, are supposed to wait for 2.6.26; however, since this=20
is a one-liner with no possible unintended consequences, it may be=20
pushed to 2.6.27.

John has been on holiday celebrating his 10'th wedding anniversary,=20
and his mailbox is certainly very full. It will take a few days before=20
we hear what he decides.

Larry

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
