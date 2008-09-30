Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:2845 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYI3UC0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 16:02:26 -0400
Received: by qw-out-2122.google.com with SMTP id 3so53300qwe.37
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 13:02:25 -0700 (PDT)
Message-ID: <69e28c910809301302w48b3d982r5ddac62e459a1ca8@mail.gmail.com> (sfid-20080930_220229_792084_D8ACF662)
Date: Tue, 30 Sep 2008 22:02:25 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Artem Antonov" <artem.v.antonov@gmail.com>
Subject: Re: [RFC/T] b43: to few loop tries in do_dummy_tx
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	"Broadcom Linux" <bcm43xx-dev@lists.berlios.de>,
	"Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <6bc534830809300934w13e88af0me7e19bd287f17af7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48E11F1E.50705@lwfinger.net>
	 <6bc534830809300934w13e88af0me7e19bd287f17af7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 30, 2008 at 6:34 PM, Artem Antonov
<artem.v.antonov@gmail.com> wrote:
> I've tested it with my bcm4318(asus wl-500gP). But there are still PHY
> transmission errors. So there should be some more reasons of these
> errors :)
>
> Best regards/

It would be good to know whether the Windows driver also suffers from
PHY transmission errors... The "hybrid" Linux driver likely does have
them, possibly even more than us, judging from its poor performance.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
