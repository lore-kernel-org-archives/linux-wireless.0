Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:43060 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYH1Kwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:52:38 -0400
Received: by ey-out-2122.google.com with SMTP id 6so95212eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 03:52:36 -0700 (PDT)
Message-ID: <1ba2fa240808280352q4a913c1cv33a6bc0998cdbcb9@mail.gmail.com> (sfid-20080828_125242_280408_B851F226)
Date: Thu, 28 Aug 2008 13:52:36 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200808281235.35449.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080827013009.GA15781@tuxdriver.com>
	 <1ba2fa240808271611v382631ecn2a24e2816562d434@mail.gmail.com>
	 <20080827233103.GE5927@tesla> <200808281235.35449.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 1:35 PM, Bruno Randolf <bruno@thinktube.com> wrote:
> On Wed, Aug 27, 2008 at 04:11:15PM -0700, Tomas Winkler wrote:
>> Last solution would be to remove this merging all together but then
>> I'm not sure if Bruno added this code just implement the spec or
>> really tested it with any hardware.
>
> of course i tested IBSS merge with atheros hardware when i sent in the patch
> and it worked. this is about 6 month ago.
recently i briefly tested IBSS,

Do you know how the  TSF is actually synchronized from the HW perspective?

> with the same HW but it did not work any more - i didn't have the time to
> investigate this issue...

There is another IBSS bug that was introduced connected to rates maybe
this is also your problem.. we have something in the pipe that should
solve this.

> please remember that there was a lengthy discussion about the standard
> compliance and the reasons behind the need for IBSS merge before my patch was
> accepted. i believe i had convincing arguments why IBSS mode does not
> reliably work at all in practice if we don't support IBSS merge.

Sure but if TSF is not adopted correctly and that's the case probably
of most of the drivers under mac80211 then it makes
worth.  Just need to be aware of this.

> you might want to re-read this thread:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/10278
>
Thanks
Tomas
