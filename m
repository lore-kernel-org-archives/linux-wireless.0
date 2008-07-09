Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:34125 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYGIUDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 16:03:11 -0400
Received: by rn-out-0910.google.com with SMTP id k40so928210rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 13:03:09 -0700 (PDT)
Message-ID: <fce2a370807091303m4699e7dbl336eddd86735619e@mail.gmail.com> (sfid-20080709_220315_017163_15F72AF9)
Date: Wed, 9 Jul 2008 23:03:08 +0300
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

Ok, just blackfin. Is it a joke or should I resend the patch with
another description?..

>
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
>
