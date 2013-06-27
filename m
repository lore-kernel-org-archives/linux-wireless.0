Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:37831 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3F0Nem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 09:34:42 -0400
Received: by mail-ee0-f49.google.com with SMTP id b57so399437eek.8
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jun 2013 06:34:41 -0700 (PDT)
Message-ID: <51CC3F6E.4050308@gmail.com> (sfid-20130627_153445_909345_1B140AA4)
Date: Thu, 27 Jun 2013 15:34:38 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: "shiki.biomernok" <shiki.biomernok@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: Re: TP-Link 8200ND - rtl8192cu module not loading / working
References: <51A77433.2060702@lwfinger.net> <51CAD0B8.3010303@gmail.com> <51CB1356.80306@lwfinger.net> <51CB250A.3060900@gmail.com> <51CB4E31.50502@lwfinger.net> <51CC0CD1.5000801@gmail.com>
In-Reply-To: <51CC0CD1.5000801@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/27/2013 11:58 AM, shiki.biomernok wrote:

> @Xose: What does that mean for me? Am I trying the wrong driver?

No, that should be the correct driver.
But it looks like rtl8192cu wasn't tested enough with 2T2R(RTL8192CUS)
devices.
