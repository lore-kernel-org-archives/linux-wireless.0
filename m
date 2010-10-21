Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0JUPS2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 11:18:28 -0400
Subject: Re: Request for free-distributable Broadcom's (G|LP)-PHY firmware
From: Dan Williams <dcbw@redhat.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
In-Reply-To: <AANLkTinfwhjvfJU6C97SPJ8YKRqyJaCoQnAcC_uKLZa=@mail.gmail.com>
References: <AANLkTik45KLdLf5UpjPtXTNgy4Df_BupyQ3SzRr6gZgC@mail.gmail.com>
	 <AANLkTin_JcEyT21dTS=Ew868HJvZQ2FVZBGXjCZn=8O_@mail.gmail.com>
	 <4CBF640C.4080405@broadcom.com>
	 <AANLkTinfwhjvfJU6C97SPJ8YKRqyJaCoQnAcC_uKLZa=@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 10:21:57 -0500
Message-ID: <1287674517.2383.7.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-21 at 00:11 +0200, Rafał Miłecki wrote:
> W dniu 20 października 2010 23:50 użytkownik Henry Ptasinski
> <henryp@broadcom.com> napisał:
> > Sorry for the delay in responding.  We are exploring what is possible but
> > for the moment the answer is no. At present our focus is on providing the
> > best open source solution we can for 4313, 43224, 43225, 4329 and future
> > chips sets.
> 
> Thanks for answer.
> 
> Please, can you make totally sure person responsible for this gets it
> totally right? I believe it's very important.
> 
> The easiest step for you, which we still would appreciate is really
> trivial one. It's *not* about writing any code, *not* about releasing
> anything new. It's just about releasing in under friendly license.
> This firmware is already available, we have access to it, we use it.
> The problem is that distributions can not ship it.
> 
> If you let me use simplification: all we need as first nice step is
> Broadcom to say: "You can use it".

That's not enough to allow Fedora to ship it.  We'd need a clear license
from Broadcom (ex the existing Intel or Marvell firmware licenses)
before Fedora could feel comfortable about shipping it legally in all
jurisdictions.

http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob;f=LICENCE.mwl8k;h=3224e1bbfba8ccd1d980f57eb88378f20bb2d146;hb=HEAD
http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob;f=LICENCE.libertas;h=1fd8766c26a170b50605455ae6f54b607baa12cf;hb=HEAD

There's an existing Broadcom license in linux-firmware.git, and it *may*
be OK, but it's really, really long and given that other major companies
adopted the "shorter is better" approach, it's hard to believe that all
the existing Broadcom license text is actually needed.

Dan


