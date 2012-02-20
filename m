Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63539 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2BTLLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 06:11:07 -0500
Received: by vbjk17 with SMTP id k17so3452044vbj.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2012 03:11:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329735923.3458.16.camel@jlt3.sipsolutions.net>
References: <CAHPDcRtEHP7LAGPDE_UDs-P9Nq_ZrQbxsMYDCt-eXvjR+5=6kQ@mail.gmail.com>
	<201202201048.01883.chunkeey@googlemail.com>
	<CAD2nsn1UWO0ix2OCkqC+xu3bX_p-pvsPk7VNv-5E=kGvKaxMUw@mail.gmail.com>
	<1329735923.3458.16.camel@jlt3.sipsolutions.net>
Date: Mon, 20 Feb 2012 16:41:06 +0530
Message-ID: <CAD2nsn3PKg5J2t-bdzrg6=pagejxtf3c0LXg1wS0ii2FGFQkmw@mail.gmail.com> (sfid-20120220_121111_313747_3D3C3B5D)
Subject: Re: AP send null-data packet?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Yingang Fu <yingang.fu@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yes, this is true, it happens when the station sends a PS-Poll but we
> timed out the frame in the meantime -- should be uncommon. In the uAPSD
> case it's more common, if nothing is pending and the station sends a
> trigger frame.

thanks!

>
> In any case, it's perfectly normal for an AP to send null data frames.

-- 
thanks,
shafi
