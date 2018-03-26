Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:33258 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750984AbeCZHnb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 03:43:31 -0400
Subject: Re: [PATCH] mac80211: Fix wlan freezes under load at rekey
To: Ben Greear <greearb@candelatech.com>,
        Alexander Wetzel <alexander.wetzel@web.de>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <20180324102921.9814-1-alexander.wetzel@web.de>
 <7bbb4246-324e-1d6d-245f-2642badb034d@candelatech.com>
 <27aca99e-a521-be4a-9fd4-51c557f9777d@web.de>
 <3e433bd6-d13e-f71c-d3ff-7163c2b59226@candelatech.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <caa084b9-ae86-af58-6295-637b549ad5b7@dd-wrt.com> (sfid-20180326_094335_379111_2BD32508)
Date: Mon, 26 Mar 2018 09:43:28 +0200
MIME-Version: 1.0
In-Reply-To: <3e433bd6-d13e-f71c-d3ff-7163c2b59226@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>
> So I really don't know enough to properly review
> your patch.  Just be aware that ath10k is weird about sw-crypt, maybe 
> make
> sure your patch is tested on it to make sure it doesn't out-right 
> break something.
i will test it today in sta and ap mode. lets see whats the result after 
some hours

Sebastian


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
