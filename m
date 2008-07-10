Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:1140 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYGJGl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 02:41:26 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Ihar Hrachyshka" <ihar.hrachyshka@gmail.com>
Subject: Re: [PATCH] libertas: fix memory alignment problems on the blackfin
Date: Thu, 10 Jul 2008 08:41:05 +0200
Cc: libertas-dev@lists.infradead.org,
	"Ihar Hrachyshka" <ihar.hrachyshka@promwad.com>,
	linux-wireless@vger.kernel.org
References: <20080709031850.2e7bf50f@promwad.com> <200807091521.04520.hs4233@mail.mn-solutions.de> <fce2a370807091303m4699e7dbl336eddd86735619e@mail.gmail.com>
In-Reply-To: <fce2a370807091303m4699e7dbl336eddd86735619e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807100841.05963.hs4233@mail.mn-solutions.de> (sfid-20080710_084129_602327_4500D188)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > You can delete the "maybe", on ARM (more specificially, on a
> > PXA255, which is ARMv5TE) I didn't had a problem.
>
> Ok, just blackfin. Is it a joke or should I resend the patch
> with another description?..

It's neither a joke (I never had any problem with my embedded 
device) nor do I insist that you change the commit message. From 
my part you'd get an ACK (but I'm not the maintainer of this 
code).
