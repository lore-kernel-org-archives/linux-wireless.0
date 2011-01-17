Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43277 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1AQTcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 14:32:46 -0500
Received: by gyb11 with SMTP id 11so2065235gyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 11:32:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295287996.3726.50.camel@jlt3.sipsolutions.net>
References: <1295284675-30029-1-git-send-email-eliad@wizery.com>
	<1295287108.3726.49.camel@jlt3.sipsolutions.net>
	<AANLkTikhz0p1SCP1Lm2qzR4TYdh3OH+vSzWBshfoG5-e@mail.gmail.com>
	<1295287996.3726.50.camel@jlt3.sipsolutions.net>
Date: Mon, 17 Jan 2011 21:32:45 +0200
Message-ID: <AANLkTim4p6gh+5zx4sDD5Prz84jpH-qkc8PECbpMRt9v@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: free firmware after booting the chip
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

it's about 270K...

i guess i'll leave it for now.
thanks!

On Mon, Jan 17, 2011 at 8:13 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-01-17 at 20:11 +0200, Eliad Peller wrote:
>> good point!
>> does loading it on suspend makes sense, or i should abandon this patch?
>
> I wouldn't, you then run into failure modes where it can't be loaded
> during suspend either, etc. It's not huge anyway, is it?
>
> johannes
>
>
