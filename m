Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:60700 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYKUUef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 15:34:35 -0500
Received: by yw-out-2324.google.com with SMTP id 9so503973ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 12:34:34 -0800 (PST)
Message-ID: <b6c5339f0811211234o61ac9431jf4eb93c857225683@mail.gmail.com> (sfid-20081121_213439_016832_DD73F239)
Date: Fri, 21 Nov 2008 15:34:33 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
Subject: Re: [ath5k-devel] Bugs in ath5k on aspire one (AR2425)
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <49271749.1060601@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <492712D9.7080004@gmail.com> <49271749.1060601@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 21, 2008 at 3:17 PM, Alan Jenkins
<alan-jenkins@tuffmail.co.uk> wrote:
> Maxim Levitsky wrote:

>> [noise calibration timeouts]
>> Only a reboot helped.

You can also do a suspend-to-ram cycle as well which effectively
reboots the card.

> A patch has been submitted which stops the card getting wedged this way,
>
> <http://www.spinics.net/lists/linux-wireless/msg23404.html>
>
> from the messages it's not clear whether this is a complete fix, or more
> of a workaround for an underlying problem.  It sounds like it got an ACK
> from another tester (and I can add mine as well!), but no-one has
> accepted or reviewed it :(.

Actually this had been in wireless-testing for a bit and got sent on to
net-next today.  The problem also had plagued me for quite a while!

-- 
Bob Copeland %% www.bobcopeland.com
