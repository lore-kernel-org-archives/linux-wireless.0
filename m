Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:34363 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754302Ab0EaBFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 May 2010 21:05:53 -0400
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0116147949
	for <linux-wireless@vger.kernel.org>; Mon, 31 May 2010 10:05:49 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable ASPM
Date: Mon, 31 May 2010 10:06:15 +0900
Cc: Pavel Roskin <proski@gnu.org>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless@vger.kernel.org
References: <20100528100901.14580.1322.stgit@fate.lan> <20100528212523.213125g8t0an4mn4@hayate.sektori.org> <1275078476.18152.10.camel@mj>
In-Reply-To: <1275078476.18152.10.camel@mj>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005311006.15282.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 May 2010 05:27:56 Pavel Roskin wrote:
> If we need to add GPL code to ath5k, it could go to a separate file.
> But if that separation becomes inconvenient, we could drop BSD
> compatibility from ath5k.  I don't see any benefit from dual licensing,
> unless some existing ath5k contributors are BSD developers who would
> stop working on the code in case of relicensing, but I don't think it's
> the case.

afaik, one of the reasons for the dual license is that *BSDs (our ancestors 
from a ath5k point of view) should be able to benefit from improvements we 
make. this applies mostly to atheros chipset related things, and is irrelevant 
for linux-only implementation specifics.

also we can mix BSD and GPL in one file - see debug.c

bruno
