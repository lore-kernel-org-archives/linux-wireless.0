Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46834 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab1CCIVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 03:21:20 -0500
Received: by iyb26 with SMTP id 26so707096iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 00:21:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20110303T091059-822@post.gmane.org>
References: <AANLkTinzfBmpJ6-O=o-zi+oh9miLRo-UZUM=MhcnQmk=@mail.gmail.com> <loom.20110303T091059-822@post.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 3 Mar 2011 00:21:00 -0800
Message-ID: <AANLkTinO8mVVFuZRJVSROr=7fGAj1G2x07KSS1c+bnNx@mail.gmail.com>
Subject: Re: Regulatory database improvements
To: jpo234 <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 3, 2011 at 12:14 AM, jpo234 <pommnitz@yahoo.com> wrote:
> Luis R. Rodriguez <mcgrof@...> writes:
>
>> If anyone has any input on this definition or would like some please
>> start thinking about it and we can start talking about it. For details
>> as to *why* we are doing this you can lok at the wiki page above or
>> also the thread:
>
> Luis,
> we have an amplifier attached to one card and not on the other in our system.
> The amplified card requires different regulatory constraints from the "normal"
> one. So, what I'd like to see are per wiphy regulatory settings, not global ones.

How does an amplifier change regulatory rules? The rules are static,
likely what you want is not per wiphy rules but per wiphy
modifications to help you comply by the additions you are making. No?

  Luis
