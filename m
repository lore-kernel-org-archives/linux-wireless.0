Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f197.google.com ([209.85.211.197]:56662 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab0BQRPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 12:15:55 -0500
Received: by ywh35 with SMTP id 35so64096ywh.4
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 09:15:54 -0800 (PST)
Message-ID: <4B7C2446.6030507@lwfinger.net>
Date: Wed, 17 Feb 2010 11:15:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: okias <d.okias@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	herton@mandriva.com.br, htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl818x: small cleanup
References: <c2673ca61002170905g788ce856uc82adc490c2328be@mail.gmail.com>
In-Reply-To: <c2673ca61002170905g788ce856uc82adc490c2328be@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2010 11:05 AM, okias wrote:
> -2 lines...

Your patch is fine, but there are problems in the presentation. For review
purposes, it should be in-line, not as an attachment. The second problem is that
the patch is for rtl8187, not for wireless/rtl818x. There are 2 drivers, soon to
be more, in that particular directory.

Larry
