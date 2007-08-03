Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:41969 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758532AbXHCSF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 14:05:57 -0400
Received: by wa-out-1112.google.com with SMTP id v27so916719wah
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2007 11:05:56 -0700 (PDT)
Message-ID: <f6ca9fed0708031105y5e87330fq1518b755a14ab028@mail.gmail.com>
Date: Fri, 3 Aug 2007 20:05:54 +0200
From: dragoran <drago01@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: rt2500usb stopped working (vendor request error)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200708032007.45875.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <46B1B0AE.7050205@gmail.com> <200708031848.03469.IvDoorn@gmail.com>
	 <f6ca9fed0708031046x639fc799wbec08f2c8e2c7536@mail.gmail.com>
	 <200708032007.45875.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ok this makes sense.
is the legacy driver supported by hostapd?

On 8/3/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Friday 03 August 2007, dragoran wrote:
> > no I havn't I will try it tomorrow and tell you if it worked.
> > but as I said before a earilier version of the driver worked before on
> > fc6 without any problems.
>
> Yes, but I want to rule out hardware problems completely.
> If legacy still works then there is nothing with the hardware,
> but indeed a driver problem.
> If the legacy driver shows the same problem, it might be a hardware problem.
>
> Ivo
>
