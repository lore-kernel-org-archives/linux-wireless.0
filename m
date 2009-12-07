Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46864 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577AbZLGPLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 10:11:05 -0500
Received: by bwz27 with SMTP id 27so3553442bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 07:11:11 -0800 (PST)
To: David Acker <dacker@roinet.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Greg Oliver <oliver.greg@gmail.com>,
	linux-wireless@vger.kernel.org, patrik.flykt@nokia.com
Subject: Re: WMM classification guideline for applications?
References: <87d42u6dnd.fsf@purkki.valot.fi> <4B19276F.5080604@roinet.com>
	<878wdi69u9.fsf@purkki.valot.fi> <4B1933F5.2010408@roinet.com>
	<51058d550912040856u5d413a06n40412f8f56eb4b9@mail.gmail.com>
	<1259954135.27022.6.camel@localhost.localdomain>
	<4B196AA7.3040603@roinet.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 07 Dec 2009 17:11:07 +0200
In-Reply-To: <4B196AA7.3040603@roinet.com> (David Acker's message of "Fri\, 04 Dec 2009 15\:01\:43 -0500")
Message-ID: <87iqci4y5w.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Acker <dacker@roinet.com> writes:

> Going with IPv4 DSCP may be a bit problematic.  See
> http://marc.info/?l=linux-netdev&m=125875775229644&w=2 and
> http://sourceware.org/bugzilla/show_bug.cgi?id=10789 .

Thanks, these are good links. 

I don't see this as an obstacle, though. If we have issues, we'll fix
them. This QoS support is such a mess that if we want to do this
properly, there is no way to avoid some pain.

-- 
Kalle Valo
