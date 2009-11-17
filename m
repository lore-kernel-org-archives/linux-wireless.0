Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:42284
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZKQVo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 16:44:27 -0500
Message-ID: <4B03193E.2080304@roinet.com>
Date: Tue, 17 Nov 2009 16:44:30 -0500
From: David Acker <dacker@roinet.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Andrey Yurovsky <andrey@cozybit.com>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de> 	<43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com> 	<4B02DFF4.1060509@roinet.com> <45e8e6c40911171257m7c687380k6e6e2677fd11f851@mail.gmail.com> <43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>
In-Reply-To: <43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Tue, Nov 17, 2009 at 12:57 PM, Andrey Yurovsky <andrey@cozybit.com> wrote:
>> On Tue, Nov 17, 2009 at 9:40 AM, David Acker <dacker@roinet.com> wrote:
>>>>>  1. What are you using MadWifi for?
>>> Wireless mesh on embedded systems.
> 
> I'm curious -- what type of Mesh were you talking about David? I
> didn't know MadWifi supported 802.11s so don't know if that is what
> you mean.
It is a non-802.11s protocol that predates 802.11s development by quite 
awhile.  It runs over WDS links.  In theory it could run over anything 
that supports dynamic creation and destruction of WDS links.


>> FWIW ath5k has working draft-802.11s mesh mode, in fact it's one of
>> the better-supported drivers.
> 
> Thanks for pointing that out Andrey.
Yes, that is good to hear.

-ack


