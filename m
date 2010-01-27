Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:47110 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab0A0Q0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 11:26:47 -0500
Received: by ywh36 with SMTP id 36so44668ywh.15
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2010 08:26:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b2cc26e41001270818hfa9a533le4aa45a5f2f62eb8@mail.gmail.com>
References: <87k4v5nuej.fsf@purkki.valot.fi>
	 <b2cc26e41001270818hfa9a533le4aa45a5f2f62eb8@mail.gmail.com>
Date: Wed, 27 Jan 2010 10:26:44 -0600
Message-ID: <51058d551001270826s19776cebl38cf86765f7395eb@mail.gmail.com>
Subject: Re: Network QoS support in applications
From: Greg Oliver <oliver.greg@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 27, 2010 at 10:18 AM, Olaf van der Spek
<olafvdspek@gmail.com> wrote:
> On Tue, Jan 26, 2010 at 9:27 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> I would like to clear up all this by and I'm willing to write a
>> document for application developers about network QoS. But I need help
>> to understand what's the proper way to mark different QoS
>> prioritities.
Yep, and I would have to disagree that the linux tools are not in use.
 A large portion (if not most) of the SMB/SME market uses appliances
that are based on the linux networking stack (when they are not using
the msoft competitor - if it exists).  Most of these also allow QoS
and traffic shaping out of the box..  Don't forget about the majority
of all of the wireless routers you write software for too :)  Most of
them use some form/combination of QoS/queues for prioritization as
well...

I do not think it is a matter of education, but rather "what do I
gain" from developers.  A lot of apps already mark packets, but in the
end, they must be trusted by the network.  I know I do not want/will
not allow any device that is not physically secure as well as
software-wise to pass packets without re-classification on my
networks...

-Greg
