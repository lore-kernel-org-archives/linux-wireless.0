Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:47121 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751267AbdIFNIp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 09:08:45 -0400
Subject: Re: hung task in mac80211
To: Johannes Berg <johannes@sipsolutions.net>,
        Stefano Brivio <sbrivio@redhat.com>,
        Matteo Croce <mcroce@redhat.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CAGnkfhwi9MmtLneeU23iWEGLj9cb1ODb3KzzOqTDvA6nNVsugg@mail.gmail.com>
 <20170906144019.1c98a636@elisabeth>
 <1504702115.13457.16.camel@sipsolutions.net>
 <1504702990.13457.19.camel@sipsolutions.net>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <6b08a34a-1c0e-452e-0e37-f721800f2a04@dd-wrt.com> (sfid-20170906_150848_603579_DC27C2B6)
Date: Wed, 6 Sep 2017 15:08:42 +0200
MIME-Version: 1.0
In-Reply-To: <1504702990.13457.19.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 06.09.2017 um 15:03 schrieb Johannes Berg:
> On Wed, 2017-09-06 at 14:48 +0200, Johannes Berg wrote:
>> I'm surprised nobody saw this before - though perhaps Sebastian's
>> useless report is the same.
> Oh, that's because this is only for the offloaded manager thing, and
> that's only ath10k.
>
> johannes
that explans the behaviour i have found with latest mac80211 and ath10k.


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
