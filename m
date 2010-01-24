Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:54597 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0AXI1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 03:27:13 -0500
Received: by ewy26 with SMTP id 26so995042ewy.28
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 00:27:11 -0800 (PST)
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>,
	Markus Baier <markus_baier@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Starting hostapd causes kernel panic
References: <loom.20100122T205326-794@post.gmane.org>
	<1264193623.2593.17.camel@johannes.local> <1264196526.3040.3.camel@mj>
	<3ef14e53bb12298507dbaec4bb0b98d3.squirrel@secure.sipsolutions.net>
	<1264197963.9056.0.camel@mj> <1264251576.2593.30.camel@johannes.local>
	<4B5B6FCA.2070900@redfish-solutions.com>
	<87aaw4oxh0.fsf@purkki.valot.fi>
	<4B5C0173.9080100@redfish-solutions.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 24 Jan 2010 10:27:08 +0200
In-Reply-To: <4B5C0173.9080100@redfish-solutions.com> (Philip A. Prindeville's message of "Sun\, 24 Jan 2010 00\:14\:43 -0800")
Message-ID: <87636rq55v.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Philip A. Prindeville" <philipp_subx@redfish-solutions.com> writes:

>>> Did you send that patch? I'd like to apply it. Please copy me when
>>> you send it out.
>> 
>> Johannes was busy and I sent the patch instead. It's here:
>> 
>> http://marc.info/?l=linux-wireless&m=126427124317427&w=2
>> 
>
> I just applied it to compat-wireless-2010-01-20 and ran it on an
> AR5413 but it still panics:
>
> BUG: unable to handle kernel NULL pointer dereference at 0000019f
> IP: [<e0993e7f>] :mac80211:invoke_tx_handlers+0x5be/0xe6a

Is there any way you could test wireless-testing kernel? I'm not
familiar with compat-wireless, so it's difficult for me to comment
anything.

But remember that there were multiple fixes related to this crash,
make sure that you have all of them in your compat-wireless tree.

-- 
Kalle Valo
