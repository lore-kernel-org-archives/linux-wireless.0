Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:56199 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0LJTAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 14:00:16 -0500
Received: by fxm18 with SMTP id 18so4113404fxm.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Dec 2010 11:00:14 -0800 (PST)
Message-ID: <4D0278D2.5030201@lwfinger.net>
Date: Fri, 10 Dec 2010 13:00:34 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Konstantinos Karantias <kostis@gtklocker.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43 N PHY status report
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>	<AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>	<4CFFA112.7030800@lwfinger.net> <AANLkTik1712si67qH6fBSLzu8iWcjqnX=ntENh0W8UmU@mail.gmail.com>
In-Reply-To: <AANLkTik1712si67qH6fBSLzu8iWcjqnX=ntENh0W8UmU@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2010 12:53 PM, Konstantinos Karantias wrote:
> It's not been so stable on my BCM4312, but it's still stable. It can
> keep the connection for ~3 hours here.

Your BCM4312 probably has an LP PHY. We were reporting on the N PHY devices.

I have 2 LP PHY units - both stay connected although one of them gets "cookie
out of order" errors on occasion. Please report the exact details for your device.

Larry
