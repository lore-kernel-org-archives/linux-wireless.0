Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47751 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2JaGVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 02:21:25 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so540881eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2012 23:21:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5090B711.70808@candelatech.com>
References: <508EB783.9080000@candelatech.com> <CAGRGNgWGfL+_u4fHEfqZAcFHb1H4Z4jFkiE4qKLU6i9XEWzZ6w@mail.gmail.com>
 <5090560D.1090708@candelatech.com> <CAGRGNgUQ40YW-dwy34nPD65XPWt1VWetyXDdd=L_NxKJ9-_Fiw@mail.gmail.com>
 <CAJ-Vmoky+46E71wQbF1-J-xEnHdWeMMXf=Yo+SGkqALjvjrJrg@mail.gmail.com> <5090B711.70808@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 31 Oct 2012 17:21:03 +1100
Message-ID: <CAGRGNgV9wH0vSP2Q395wBGiowaY-LHVJ5JNuJYzQNvacTDdG_w@mail.gmail.com> (sfid-20121031_072132_157388_7CE96322)
Subject: Re: Any thoughts on how to best shield u.fl connectors on NICs?
To: Ben Greear <greearb@candelatech.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Wed, Oct 31, 2012 at 4:28 PM, Ben Greear <greearb@candelatech.com> wrote:
> Two things come to mind:
>
> First, I'd like to put 2+ NICs close together in the same chassis.
> Would be nice if they were as isolated from each other as possible
> so that each NIC could work independently of the other (once I can
> get to SMA connectors, there are > 90db shielded cable options,
> but of course it could just go to antenna where it all mixes again
> anyway).
>
> Second:  If one wants to use an attenuator and coax cables to connect
> AP and Station systems together, the AP and Station need to NOT also
> be transmitting through the air.  Anything I can do to keep that
> over-the-air communication minimal should help.
>
> Truth is, I'm not sure how much it really matters, but after a few weeks

To be quite honest, if I were doing this, I'd be making a custom
chassis that had shielded partitions to house the NICs and probably
use something like this to get signal to the NICs:

https://encrypted.google.com/search?q=pcie+extension+cable

But this would be getting towards the construction of some serious
test equipment.

What are you trying to achieve here?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
