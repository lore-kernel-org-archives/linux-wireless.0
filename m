Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50930 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1AQSLx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 13:11:53 -0500
Received: by ywl5 with SMTP id 5so1761953ywl.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 10:11:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295287108.3726.49.camel@jlt3.sipsolutions.net>
References: <1295284675-30029-1-git-send-email-eliad@wizery.com>
	<1295287108.3726.49.camel@jlt3.sipsolutions.net>
Date: Mon, 17 Jan 2011 20:11:52 +0200
Message-ID: <AANLkTikhz0p1SCP1Lm2qzR4TYdh3OH+vSzWBshfoG5-e@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: free firmware after booting the chip
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

good point!
does loading it on suspend makes sense, or i should abandon this patch?

On Mon, Jan 17, 2011 at 7:58 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-01-17 at 19:17 +0200, Eliad Peller wrote:
>> There is no need to save the fw in memory after it has been
>> uploaded to the chip.
>
> Are you sure it's not needed for resume? At which point userspace isn't
> up so you can't load it.
>
> johannes
>
>
