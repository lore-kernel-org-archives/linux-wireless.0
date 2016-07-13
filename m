Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33563 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbcGMJOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 05:14:11 -0400
Received: by mail-oi0-f47.google.com with SMTP id j185so54821261oih.0
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 02:14:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cac14ead-1af5-ff1d-5b35-592933882aae@nbd.name>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
 <CAA93jw6=_pemSUjk3dje1GmnTzrs+=pEdza4j1Wjtrw+VKNdNg@mail.gmail.com>
 <097af8e4-5393-8e1b-1748-36233e605867@nbd.name> <CAA93jw4GQknawtp6Lo3ZM8=qW=p2eTnZ_krC7AvnNbKwp8R5SQ@mail.gmail.com>
 <CAA93jw7y_dp=AMFB3Nj7TK08PXmdypKBnfAZ_FfnWXOt-+aL2Q@mail.gmail.com> <cac14ead-1af5-ff1d-5b35-592933882aae@nbd.name>
From: Dave Taht <dave.taht@gmail.com>
Date: Wed, 13 Jul 2016 11:13:54 +0200
Message-ID: <CAA93jw5caCtm5Wgkp0-mMZmGTtiGty13Yz1ha20LBa43TavZpQ@mail.gmail.com> (sfid-20160713_111416_430392_293FE698)
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: Felix Fietkau <nbd@nbd.name>
Cc: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	=?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 13, 2016 at 10:53 AM, Felix Fietkau <nbd@nbd.name> wrote:

>> To me this implies a contending lock issue, too much work in the irq
>> handler or too delayed work in the softirq handler....
>>
>> I thought you were very brave to try and backport this.
> I don't think this has anything to do with contending locks, CPU
> utilization, etc. The code does something to the packets that TCP really
> doesn't like.

With your 70% idle figure, I am inclined to agree... could you get an aircap
of the two different tests?  - as well as a regular packetcap taken at
the client or server?
And put somewhere I can get at them?

What version of OSX are you running?

I will setup an ath9k box shortly...


-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
