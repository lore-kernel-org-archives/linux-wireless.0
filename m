Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50926 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0AROQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 09:16:09 -0500
Received: by ewy19 with SMTP id 19so580845ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2010 06:16:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c911001171628s684df11avb3e9f9586e64b69e@mail.gmail.com>
References: <op.u6o9tvst9lhzdc@linux-g0th.site>
	 <69e28c911001171628s684df11avb3e9f9586e64b69e@mail.gmail.com>
Date: Mon, 18 Jan 2010 15:16:08 +0100
Message-ID: <b170af451001180616w5d79411fka3835e8da04e2bcf@mail.gmail.com>
Subject: Re: [PATCH 2/5 V2] b43: N-PHY: implement and add multi-dimensional
	table writing
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 18 stycznia 2010 01:28 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
> 2010/1/18 Rafał Miłecki <zajec5@gmail.com>:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> V2: updated to apply without fuzz
>
> Actually, you do not need to do that - offset or fuzzy patches will
> still be applied cleanly AFAIK, without any intervention.
> (John, correct me if I'm wrong here...)

That's right, it actually did. I just wanted to don't bother John with
wondering if everything gone correctly. I guess I could just mention
it instead of sending patch :)

-- 
Rafał
