Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2776 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757596Ab2EGUOP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 16:14:15 -0400
Message-ID: <4FA82D09.3010001@broadcom.com> (sfid-20120507_221420_477753_99E763F0)
Date: Mon, 7 May 2012 22:14:01 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "David Miller" <davem@davemloft.net>
cc: lucas.demarchi@profusion.mobi, andrei.emeltchenko.news@gmail.com,
	dh.herrmann@googlemail.com, gustavo@padovan.org,
	linville@tuxdriver.com, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix coding style
References: <20120507081411.GA19002@aemeltch-MOBL1>
 <20120507.115228.1171858914064928263.davem@davemloft.net>
 <CAMOw1v474CTigis2xNBF53YP-NMt2XmMR_zvqNAeN8kmEQjxGA@mail.gmail.com>
 <20120507.160609.1784484093679983272.davem@davemloft.net>
In-Reply-To: <20120507.160609.1784484093679983272.davem@davemloft.net>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2012 10:06 PM, David Miller wrote:
> From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> Date: Mon, 7 May 2012 16:49:16 -0300
> 
>> Doing so also means we don't create our own rules and impose them on
>> others, like happened some time ago
>> (https://lkml.org/lkml/2012/4/16/473).
> 
> You conveniently forgot to show that Linus said that it's OK for a
> subsystem maintainer to request that kind of coding style, it's just
> not OK to impose it tree-wide.

Actually, checkpatch.pl does validate the rule being discussed here.
That could be regarded as imposing it. The SubmittingPatches document
states the following:

"At a minimum you should check your patches with the patch style
checker prior to submission (scripts/checkpatch.pl).  You should
be able to justify all violations that remain in your patch."

Gr. AvS



