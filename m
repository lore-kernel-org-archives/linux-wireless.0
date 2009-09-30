Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:28742 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZI3A5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 20:57:43 -0400
Received: by ey-out-2122.google.com with SMTP id 4so393891eyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 17:57:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909300017.20949.malte.gell@gmx.de>
References: <999306.93095.qm@web23102.mail.ird.yahoo.com>
	 <200909291145.35972.malte.gell@gmx.de>
	 <3ace41890909290328l14620ed6o4939488e268d76a3@mail.gmail.com>
	 <200909300017.20949.malte.gell@gmx.de>
Date: Wed, 30 Sep 2009 01:57:45 +0100
Message-ID: <3ace41890909291757g29851b15v64cb55241ad3d69@mail.gmail.com>
Subject: Re: compat-wireless tracepoint error Re: [Ndiswrapper-general] Need
	help to create driver for Netgear WN111v2
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Malte Gell <malte.gell@gmx.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2009 at 11:17 PM, Malte Gell <malte.gell@gmx.de> wrote:
>
> "Hin-Tak Leung" <hintak.leung@gmail.com> wrote
>
>>
>> Argh... try changing this line  in config.mk
>>
>> ifndef CONFIG_COMPAT_WIRELESS_28
>>
>> to ...27.
>
> Hello,
>
> it was a pain with my Kernel 2.6.27.29 I now updated to kernel 2.6.31-44 (from
> openSUSE) and voila, it now works like a charm! I compiled the bleeding edge
> compat-wireless and it just works fine now! As I initially suspected, 2.6.27
> only made trouble.
>
> Regards
> Malte
>

Glad to hear.

Hin-Tak
