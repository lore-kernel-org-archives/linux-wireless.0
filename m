Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40093 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab2DSPvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 11:51:50 -0400
Received: by pbcun15 with SMTP id un15so10393029pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 08:51:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334849651.1980.6.camel@dcbw.foobar.com>
References: <20120409202402.8523E9D401E@zog.reactivated.net>
	<1334849651.1980.6.camel@dcbw.foobar.com>
Date: Thu, 19 Apr 2012 09:51:49 -0600
Message-ID: <CAMLZHHRRCCkm7CybYx=2Mp+boS=-vsfL+6UOJ=RjTy6t1F5UXg@mail.gmail.com> (sfid-20120419_175204_446573_F23FBFF7)
Subject: Re: [RFT] libertas SPI: convert to asynchronous firmware loading
From: Daniel Drake <dsd@laptop.org>
To: Dan Williams <dcbw@redhat.com>, anarsoul@gmail.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vasily,

On Thu, Apr 19, 2012 at 9:34 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2012-04-09 at 21:24 +0100, Daniel Drake wrote:
>> Signed-off-by: Daniel Drake <dsd@laptop.org>
>> ---
>>  drivers/net/wireless/libertas/if_spi.c |  137 +++++++++++++++++++------------
>>  1 files changed, 84 insertions(+), 53 deletions(-)
>>
>> Request for testing.
>
> It looks sane to me from a quick review.  so unless somebody can
> actually test this we'll probably have to push the patch...

Can you please test this patch for us?

Thanks
Daniel
