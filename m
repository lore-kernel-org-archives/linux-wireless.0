Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38231 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753408AbZI2Irx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 04:47:53 -0400
From: Malte Gell <malte.gell@gmx.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: cannot compile compate-wirless snapshots
Date: Tue, 29 Sep 2009 10:47:53 +0200
Cc: linux-wireless@vger.kernel.org
References: <200909260457.21103.malte.gell@gmx.de> <4ABDE7AC.1090409@hauke-m.de>
In-Reply-To: <4ABDE7AC.1090409@hauke-m.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909291047.53775.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, sorry for my late reply....

Hauke Mehrtens <hauke@hauke-m.de> wrote

> Malte Gell wrote:
> > Hello,
> >
> > actually I can build the stable compat-wirless-2.6.30.ta.bz2 just fine.
> >
> > But I get make errors, when I try to build the daily snapshot, see below.
> > I use openSUSE on a 2.6.27 kernel.

> what kernel are you using? 

2.6.27.29-0.1 from openSUSE 11.1

> Does this file exists in your installation?
> /lib/modules/`uname -r`/build/include/linux/tracepoint.h ?

Yes ! The kernel tracepoint API is there in openSuSE11.1, but I still cannot 
compile compat-wireless-2.6

 Besides tracepoint thing, does ar9170us require 2.6.29? As said, tracepoint 
does exist in my kernel....

thanx
Malte
