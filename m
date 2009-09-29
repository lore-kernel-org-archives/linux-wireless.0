Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34098 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750699AbZI2WRU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 18:17:20 -0400
From: Malte Gell <malte.gell@gmx.de>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: compat-wireless tracepoint error Re: [Ndiswrapper-general] Need help to create driver for Netgear WN111v2
Date: Wed, 30 Sep 2009 00:17:20 +0200
Cc: linux-wireless@vger.kernel.org
References: <999306.93095.qm@web23102.mail.ird.yahoo.com> <200909291145.35972.malte.gell@gmx.de> <3ace41890909290328l14620ed6o4939488e268d76a3@mail.gmail.com>
In-Reply-To: <3ace41890909290328l14620ed6o4939488e268d76a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909300017.20949.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


"Hin-Tak Leung" <hintak.leung@gmail.com> wrote

> 
> Argh... try changing this line  in config.mk
> 
> ifndef CONFIG_COMPAT_WIRELESS_28
> 
> to ...27.

Hello,

it was a pain with my Kernel 2.6.27.29 I now updated to kernel 2.6.31-44 (from 
openSUSE) and voila, it now works like a charm! I compiled the bleeding edge 
compat-wireless and it just works fine now! As I initially suspected, 2.6.27 
only made trouble.

Regards
Malte
