Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53989 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2KHMVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 07:21:03 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1503414eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 04:21:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9983E05C-2103-49C8-A675-4F5368F53FB5@mac.com>
References: <509B73D5.5000206@mac.com> <CAGRGNgUB_7NZTnC2k2_f0_bAP0yu4cXTqk3_QpxpKZHqw__+hw@mail.gmail.com>
 <9983E05C-2103-49C8-A675-4F5368F53FB5@mac.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 8 Nov 2012 23:20:40 +1100
Message-ID: <CAGRGNgXj2rkiHw1D4HqRCyX6yJCDq75k1KtS0OR+t4En+wa_jA@mail.gmail.com> (sfid-20121108_132116_136649_7EC85475)
Subject: Re: "mac80211.ko" and "cfg80211.ko" compatibility issue.
To: Nonaka Akira <nonaka@mac.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nonaka,

On Thu, Nov 8, 2012 at 10:33 PM, Nonaka Akira <nonaka@mac.com> wrote:
> Hi Julian,
>
> Well, We consider the option of using the entire compat-wireless drivers. However, we are planning the minor update of our product toward the end of the year and I thought it will be nice if I can keep the change minimum.

In general, the drivers in compat-wireless are more stable and have
more features than the versions in older kernels. (it is a back-port
of newer wireless drivers after all)

I would expect that you'll spend more time working out a solution to
use it for a single driver than you'd spend testing it on the hardware
you intend to support.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
