Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42473 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2HWKfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 06:35:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAF1ivSZ63Zr9STz3NnLV=ynRftMokG=ZGghd+cQu=HRUsiH+EA@mail.gmail.com>
References: <CAF1ivSZ63Zr9STz3NnLV=ynRftMokG=ZGghd+cQu=HRUsiH+EA@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 23 Aug 2012 20:34:44 +1000
Message-ID: <CAGRGNgWddAH3UyYq5T7iT+FuX8ajdGpP6rfjjCUkZZpiCoTmpQ@mail.gmail.com> (sfid-20120823_123512_435130_A3C7D4D7)
Subject: Re: wireless router performance differ with 2.4Ghz vs 5.0Ghz frequency
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: linux-wireless@vger.kernel.org, networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Aug 23, 2012 at 2:50 PM, Lin Ming <mlin@ss.pku.edu.cn> wrote:
> Hi list,
>
> I have a wireless router with 2 wireless cards: 2.4Ghz and 5.0Ghz frequency.
>
> The performance for 2.4Ghz is much worse than 5.0Ghz.
>
> Does the frequency affect performance so much?

There are a lot of factors:
- Amounts of other networks on the same channel
- Noise
- Signal strength
etc.

It's quite possible that there are less networks on 5GHz channels
where you are so there's less noise, stronger signal, and therefore
better performance. Most routers are still only 2.4GHz.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
