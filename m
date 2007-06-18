Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.234]:12281 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbXFRMZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2007 08:25:11 -0400
Received: by wx-out-0506.google.com with SMTP id t15so1483454wxc
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2007 05:25:10 -0700 (PDT)
Message-ID: <1ba2fa240706180525i561b0abex6c39d18e7b7b461e@mail.gmail.com>
Date: Mon, 18 Jun 2007 15:25:10 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: phy mode, channel -> freq mapping (was RE: more nl80211/iw tool code comments)
Cc: "Sandesh Goel" <sgoel@marvell.com>,
	"David Lamparter" <lists@diac24.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1182164508.5924.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <1181759017.29767.117.camel@johannes.berg>
	 <20070614142925.GA24414@charon.n2.diac24.net>
	 <285925A4DF50FC408669C6302216838D024899@sc-exch02.marvell.com>
	 <1182164508.5924.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/18/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
> > I think it is cleaner to define a parameter called BAND which can take
> > values 2.4 GHz, 5 GHz and so on. Then, the combination of BAND and
> > CHANNEL will uniquely define the operating frequency.
>
> <phymode stuff snipped>
>
> > I wasn't sure if this has already been thought about. I look forward to
> > being educated if I am missing something.
>
> Good point. I hadn't really considered this but a/g or n cards really
> make it necessary to distinguish here, and regulatory stuff would also
> benefit from defining it that way.
>
I have to agree that the phymode lost is relevance. and band channel
couple has more meaning

In this context, what atheros turbo phy mode is? What channel, band
does it operate?

Thanks
Tomas

> johannes
>
>
