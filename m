Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56422 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170AbZLDVBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 16:01:41 -0500
Received: by ewy19 with SMTP id 19so3341150ewy.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2009 13:01:47 -0800 (PST)
To: Dan Williams <dcbw@redhat.com>
Cc: Greg Oliver <oliver.greg@gmail.com>,
	David Acker <dacker@roinet.com>,
	linux-wireless@vger.kernel.org, patrik.flykt@nokia.com
Subject: Re: WMM classification guideline for applications?
References: <87d42u6dnd.fsf@purkki.valot.fi> <4B19276F.5080604@roinet.com>
	<878wdi69u9.fsf@purkki.valot.fi> <4B1933F5.2010408@roinet.com>
	<51058d550912040856u5d413a06n40412f8f56eb4b9@mail.gmail.com>
	<1259954135.27022.6.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 04 Dec 2009 23:01:43 +0200
In-Reply-To: <1259954135.27022.6.camel@localhost.localdomain> (Dan Williams's message of "Fri\, 04 Dec 2009 11\:15\:35 -0800")
Message-ID: <87vdgm4fns.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> On Fri, 2009-12-04 at 10:56 -0600, Greg Oliver wrote:
>
>> I do nto mean to be negative, but how can vlan based priority mapping
>> be anything but "going in reverse" by today's QoS standards?  The
>> whole point of packet marking is to alleviate the "this port is better
>> than that port", so traffic from any port can be made equal to that of
>> another..  Port (vlan/subnet/interface, etc) agnostic...  This would
>> seem like a regression to me...  All of the major router/switch
>> vendors provide mappings between these techniques already for this
>> reason.  Hopefully, they will not be needed much longer.
>
> Also, I think that unless it's a simple as a setsockopt() or some
> one-call method like that, app writers aren't really going to use it.

Exactly. It needs to be so simple that application developers can just
copy paste it to their code without a second thought. Remember we (as
in community) want even proprietary applications like skype to support
this.

And this method, whatever it will be, should be universal so that it
can be used with different technologies: Wi-Fi, Wimax, cellular data
and whatnot. Otherwise it doesn't make any sense, usually applications
don't care over which technology the packets are transmitted.

-- 
Kalle Valo
