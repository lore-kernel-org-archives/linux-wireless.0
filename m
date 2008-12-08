Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:34306 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYLHUZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 15:25:46 -0500
Received: by yw-out-2324.google.com with SMTP id 9so539124ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 12:25:44 -0800 (PST)
Message-ID: <445f43ac0812081225o516ad4a9ye86557b720e1b81@mail.gmail.com> (sfid-20081208_212611_337075_FA803CEB)
Date: Mon, 8 Dec 2008 12:25:44 -0800
From: "Javier Cardona" <javier@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 user space
Cc: igor_trindade@yahoo.com.br, "Jouni Malinen" <j@w1.fi>,
	"Andrey Yurovsky" <andrey@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228765954.22164.117.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <456087.50493.qm@web59308.mail.re1.yahoo.com>
	 <1228658260.22164.41.camel@johannes.berg>
	 <445f43ac0812081017q2ac6ae1h84a86099518773cc@mail.gmail.com>
	 <1228765954.22164.117.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Mon, Dec 8, 2008 at 11:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-12-08 at 10:17 -0800, Javier Cardona wrote:
>
>> To be useful for our mesh tests this "virtual air" would have to allow
>> us to create 3 groups, each one a superset of the previous.  The
>> smallest group would be the set of nodes that can a node communicate
>> with ("A can talk to B").  The next larger group would be nodes on
>> which a node that can interfere ("A can screw up C's reception").
>> Finally, the largest would be nodes that can detect each other ("A can
>> detect when D is transmitting").
>
> That's something we can't actually simulate since you're trying to see
> whether they do NAV updates correctly, right?

I was trying to simulate hidden nodes, which are unavoidable given the
distributed nature of the mesh.
Also trying to simulate "starvation at the edges", which varies
greatly with the collision avoidance threshold.
But, hey, I was just day dreaming.  Even the simpler air groups that
you proposed would be very useful.

Thanks!

Javier

-- 
Javier Cardona
cozybit Inc.
