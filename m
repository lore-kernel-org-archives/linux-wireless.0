Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:28341 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYI2Ik0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 04:40:26 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1927461fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 01:40:24 -0700 (PDT)
Message-ID: <1ba2fa240809290140i5a47d534qa30f9088df834162@mail.gmail.com> (sfid-20080929_104030_316276_AD540D0C)
Date: Mon, 29 Sep 2008 11:40:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Andres Freund" <andres@anarazel.de>
Subject: Re: bad DMAR interaction with iwlagn and SATA
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Muli Ben-Yehuda" <muli@il.ibm.com>,
	"Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200809291027.50453.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200809251511.20132.andres@anarazel.de>
	 <1222441955.3798.13.camel@johannes.berg>
	 <1ba2fa240809261630y7a8e5f20g75ab47ff98a1e614@mail.gmail.com>
	 <200809291027.50453.andres@anarazel.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 29, 2008 at 11:27 AM, Andres Freund <andres@anarazel.de> wrote:
> Hi,
>
> On Saturday 27 September 2008, Tomas Winkler wrote in "Re: bad DMAR
> interaction with iwlagn and SATA":
>> Meanwhile it all reported bugs in this case points to 64 bit
>> installations, I'll give it more testing
> Would it help to test on 32bit? I have some dissk with 32bit system installed
> lying around somewhere...

It would help to try to isolate this as 64 bit issue

> Any other patches to try?

I've posted few patches lately to address some RX buffers issues you
may to try those. Not sure it will help though.
http://marc.info/?l=linux-wireless&m=122241327108723&w=2
http://marc.info/?l=linux-wireless&m=122241327208729&w=2

Thanks
Tomas
