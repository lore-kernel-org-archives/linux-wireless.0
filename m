Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:51184 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYLBT1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 14:27:36 -0500
Received: by fk-out-0910.google.com with SMTP id 18so2560623fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 11:27:35 -0800 (PST)
Message-ID: <45e8e6c40812021127s4db52598n5541ea78f583013e@mail.gmail.com> (sfid-20081202_202740_564709_A2F63F25)
Date: Tue, 2 Dec 2008 11:27:34 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: Keir <keirlawson@gmail.com>
Subject: Re: Problems with o11s
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <e27b78a40812020752o396b2542kfc26b55caeade8df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e27b78a40812020752o396b2542kfc26b55caeade8df@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Keir.  I believe you're using ath5k?  You can use, at this time, up
to (but not including) commit
dc300b5c5291d779a53d83af960fdf9388bf0544, where we have a regression
in the driver when the PCU-related code was updated.  Have you tried
testing IBSS mode in your setup?

  -Andrey

On Tue, Dec 2, 2008 at 7:52 AM, Keir <keirlawson@gmail.com> wrote:
> Hi,
>
> I've had o11s working for a while now, but I seem to get a strange problem
> whereby pinging between MPs works for the first few pings, and then I start
> getting packet loss (Destination Host Unreachable)  and nothing gets
> through, despite the other station being listed as "ESTAB" by iw.  I'm not
> sure if there is something strange about my setup, or this is a bug
> somewhere, anyone got any ideas? I'm using revision
> d059b2aed9e93cb94364e01374bca90ce3dc0ef9
>
> Cheers
>
> Keir
>
