Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:51950 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYGIVH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 17:07:58 -0400
Received: by yx-out-2324.google.com with SMTP id 8so914737yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 14:07:57 -0700 (PDT)
Message-ID: <fce2a370807091407h124fc10en64f56d5211748ae2@mail.gmail.com> (sfid-20080709_230801_639826_25E1D8BB)
Date: Thu, 10 Jul 2008 00:07:57 +0300
From: "Ihar Hrachyshka" <ihar.hrachyshka@gmail.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH] libertas: fix memory alignment problems on the blackfin
Cc: libertas-dev@lists.infradead.org,
	"Ihar Hrachyshka" <ihar.hrachyshka@promwad.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200807091521.04520.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080709031850.2e7bf50f@promwad.com>
	 <200807091521.04520.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 9, 2008 at 4:21 PM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
>> Fixing unaligned memory access on the blackfin architecture
>> (maybe on the ARM also).
>
> You can delete the "maybe", on ARM (more specificially, on a
> PXA255, which is ARMv5TE) I didn't had a problem.

As I know, ARMs are too different to say about some "generic" ARM
behavior, in memory alignment also I think.
Too be more correct, the patch fixes alignment problems on all
machines where structures aren't aligned for even addresses by
default, blackfin, arm, or anything else I don't know about.

>
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
>
