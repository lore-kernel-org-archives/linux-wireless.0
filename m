Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:48652 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZFVOve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 10:51:34 -0400
Received: by fg-out-1718.google.com with SMTP id d23so574610fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 07:51:36 -0700 (PDT)
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Balaji Ravindran <b@w1an.in>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mircea Gherzan <mgherzan@gmail.com>
Subject: Re: Proposal enquiry for Wireless Roaming feature enhancement
References: <4A38672F.9090904@w1an.in> <87hbyfmlds.fsf@litku.valot.fi>
	<1245231411.20613.3.camel@johannes.local>
	<87bpol90z5.fsf@litku.valot.fi>
	<1245681796.4338.24.camel@dhcp-100-3-98.bos.redhat.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 22 Jun 2009 17:51:32 +0300
In-Reply-To: <1245681796.4338.24.camel@dhcp-100-3-98.bos.redhat.com> (Dan Williams's message of "Mon\, 22 Jun 2009 10\:43\:16 -0400")
Message-ID: <87k534nwy3.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

>> >  2) a way of telling userspace whether or not it has to handle
>> >  roaming, now that new cards are showing up (iwm) that can handle it
>> >  themselves
>> 
>> What about older fullmac cards, do they support roaming in hardware?
>
> Yes.  airo at least, and I think also atmel, orinoco, but not Libertas.
> Most of the fullmac cards do handle roaming between BSSIDs in the same
> SSID transparently.  Libertas on the other hand pushes that control to
> the driver.

Can you tell anything about the configuration parameters available? For
example, can the driver configure an rssi threshold for enabling
background scanning[1]?

[1] I'm sure there are N+1 different names for this

-- 
Kalle Valo
