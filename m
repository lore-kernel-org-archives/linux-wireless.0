Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:49885 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbYKKHte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 02:49:34 -0500
To: "Dan Williams" <dcbw@redhat.com>
Cc: Cliff Brake <cliff.brake@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: wi-fi.org certification with libertas + 8686
References: <f96d234e0811101325u9851ea1l636c46cf38aa2695@mail.gmail.com>
	<1226353218.8146.21.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 11 Nov 2008 09:49:10 +0200
In-Reply-To: <1226353218.8146.21.camel@localhost.localdomain> (ext Dan Williams's message of "Mon\, 10 Nov 2008 16\:40\:18 -0500")
Message-ID: <87vduuvh1l.fsf@nokia.com> (sfid-20081111_084938_822757_1543DE7D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> On Mon, 2008-11-10 at 16:25 -0500, Cliff Brake wrote:
>> Hello,
>> 
>> Has anyone been through wifi certification with the libertas driver
>> and the 8686 chipset (or any Linux driver + wpa_supplicant for that
>> matter)?  Just trying to get a rough idea how painful this is.
>
> Marvell has probably certified their libertas vendor driver (which isn't
> the upstream libertas driver).  With the possible exceptions of Intel
> and Atheros (which are both heavily involved in the upstream drivers for
> their hardware), none of the upstream kernel drivers have been through
> validation or certification that I know of.

I think Intel mentioned that they have run some Wi-Fi certification
tests with mac80211. Don't know if it were the official certification
or what.

Nokia N800 and N810 are certified, but we had a proprietary driver and
supplicant. The certification is painful, I recommend reserving lots
of time for it.

-- 
Kalle Valo
