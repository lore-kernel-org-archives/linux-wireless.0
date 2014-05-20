Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:42881 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaETIY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 04:24:29 -0400
Received: by mail-ob0-f178.google.com with SMTP id va2so123439obc.9
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 01:24:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140520101825.3d928446@wiggum>
References: <1400568385-26182-1-git-send-email-zajec5@gmail.com>
	<537AFAA0.3070401@meshcoding.com>
	<CACna6rwa6zKX=ngSQhmWTrZcy_W7fjMrTmQ-A8XURZCVMX1nrA@mail.gmail.com>
	<537AFFEB.1040707@meshcoding.com>
	<CACna6ryTSKim3ckZsJnE_1zrXW-JFabZSaJrLrOFL+JgXzLLjQ@mail.gmail.com>
	<20140520101825.3d928446@wiggum>
Date: Tue, 20 May 2014 10:24:28 +0200
Message-ID: <CACna6rzG9ePT5BtBjgMcCbsznNyB_cVm94A=6U+a2D=HsgdaRQ@mail.gmail.com> (sfid-20140520_102436_246565_83DE191E)
Subject: Re: [PATCH] b43: xmit: set 5 GHz bit depending on current band
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: Antonio Quartulli <antonio@meshcoding.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2014 10:18, Michael Büsch <m@bues.ch> wrote:
> On Tue, 20 May 2014 09:23:28 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> You're probably right. It's just a bit historical, it matches bcm47xx
>> specs, Broadcom's public code, Broadcom headers and probably their
>> internal specs. That's why I didn't decide to really touch it, to
>> avoid confusion when comparing specs with the code.
>
>
> The thing is that the actual hardware bit is called GMODE.
> I guess we could rename that variable and add a comment, if it's really an issue.
> But not the #define for the hardware bit.

Thanks for your comment. In V2 I've extended "gmode" comment slightly,
so I hope it'll be fine now.
