Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33493 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZIYPH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 11:07:28 -0400
Received: by fxm18 with SMTP id 18so2270116fxm.17
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 08:07:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909251047.46826.m.alessandrini@deit.univpm.it>
References: <200909251047.46826.m.alessandrini@deit.univpm.it>
Date: Fri, 25 Sep 2009 16:07:30 +0100
Message-ID: <3ace41890909250807y6d178f34m6a47016173b87f97@mail.gmail.com>
Subject: Re: zd1211rw on Debian not working with new kernels
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Michele Alessandrini <m.alessandrini@deit.univpm.it>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/9/25 Michele Alessandrini <m.alessandrini@deit.univpm.it>:
> Hi everybody,
> I have a Sitecom WL-113 USB wireless adapter, and I use Debian testing with
> zd1211rw. My wireless network uses WPA.
> The adapter is working with kernel up to 2.6.24. It is not working anymore
> with kernels 2.6.26 and 2.6.30 (these are the kernels I could test).
> From what I can see, wpa_supplicant gets a series of errors from the driver
> when it tries to associate to the network.
> Provided that the OS is exactly the same, and the only variable is which
> kernel is booted, I think it's something related to the driver (kernel 2.6.26
> is where the MAC layer has been changed) or to the interface between it and
> wpa_supplicant.
> I'm just writing to ask if this is a know issue or if someone else is getting
> similar problems.
> Thank you very much for your work
> Bye
> Michele Alessandrini, Italy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I am quite sure you are mistaken. Debian ships a version of the
vendor/vendor-derived driver up to 2.6.24(?) and I don't know when
they switch over. You should approach the debian people on your
problem.
