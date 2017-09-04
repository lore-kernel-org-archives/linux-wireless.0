Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:55367 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753912AbdIDRuk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 13:50:40 -0400
Subject: Re: current wireless-next mac80211 test result
To: Tom Psyborg <pozega.tomislav@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <e7efa293-0356-559d-fb19-78507ea21606@dd-wrt.com>
 <CAKR_QVLJsaduZkoqpHjPbzQL6B4uVcXnme2eXz1P0FHoBoP4Cw@mail.gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <87c9220c-f0bd-2163-cbc0-4516c5280b94@dd-wrt.com> (sfid-20170904_195045_789965_DD67A0FD)
Date: Mon, 4 Sep 2017 19:50:41 +0200
MIME-Version: 1.0
In-Reply-To: <CAKR_QVLJsaduZkoqpHjPbzQL6B4uVcXnme2eXz1P0FHoBoP4Cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i compared the sources and they are identical to the latest wireless-next


Am 04.09.2017 um 17:00 schrieb Tom Psyborg:
> Hi
>
> Have you tried 
> https://mirror2.openwrt.org/sources/compat-wireless-2017-08-25.tar.xz 
> to see if it contains same issues?
>
> On 4 September 2017 at 16:08, Sebastian Gottschall 
> <s.gottschall@dd-wrt.com <mailto:s.gottschall@dd-wrt.com>> wrote:
>
>     I tested yesterday the current wireless-next tree with backports
>     and openwrt and also dd-wrt and ath10k
>
>     after a few minutes the load was up to 50.0 . after downgrading
>     just mac80211 to the january version but still using latest ath10k
>
>     with some small mods to fit to the api, everything was back to
>     normal again. since some ioctls i used for a special kernel driver
>     deadlocked at the same time
>
>     where the load was getting high, it seems for me like a deadlock
>     problem in mac802.11 using some big fat kernel lock. didnt had
>     much time for more research. just wanted to give that information
>     to this group
>
>     -- 
>     Mit freundlichen Grüssen / Regards
>
>     Sebastian Gottschall / CTO
>
>     NewMedia-NET GmbH - DD-WRT
>     Firmensitz:  Berliner Ring 101, 64625 Bensheim
>     Registergericht: Amtsgericht Darmstadt, HRB 25473
>     Geschäftsführer: Peter Steinhäuser, Christian Scheele
>     http://www.dd-wrt.com
>     email: s.gottschall@dd-wrt.com <mailto:s.gottschall@dd-wrt.com>
>     Tel.: +496251-582650 <tel:%2B496251-582650> / Fax: +496251-5826565
>     <tel:%2B496251-5826565>
>
>

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
