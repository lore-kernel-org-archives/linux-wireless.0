Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:36695 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbcJ3Xns (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Oct 2016 19:43:48 -0400
To: James Cloos <cloos@jhcloos.com>, linux-wireless@vger.kernel.org
References: <m3oa21ftno.fsf@carbon.jhcloos.org>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <f8094de7-1357-a9d0-fee3-b28e06dd3bc7@dd-wrt.com> (sfid-20161031_004427_205565_91DE096B)
Date: Mon, 31 Oct 2016 00:43:46 +0100
MIME-Version: 1.0
In-Reply-To: <m3oa21ftno.fsf@carbon.jhcloos.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Subject: Re: Backwards 11ac
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k cannot show tx rates right now in a easy way. since tx rate 
handling is done by the cards own firmware and not by the mac80211 
wireless stack

Sebastian

Am 30.10.2016 um 21:50 schrieb James Cloos:
> I recently received my turris omnia and put it into operation yesterday.
>
> (It is only doing wireless; I have a different box for my main router.)
>
> All of the machines on the wlan show backwards transfer speeds; they
> upload reasonable fast but downloads are in the kbit/s range.
>
> That applies to the both the 11ac-capable machines and the 11n-on-2.4
> machines.
>
> Luci's status/overview page shows 'Bitrate: 6 Mbit/s' for the ath10k and
> 'Bitrate: 61.5 Mbit/s' for the ath9k.
>
> (The two wireless cards in it are:
>
> 01:00.0 Network controller: Qualcomm Atheros AR9287 Wireless Network Adapter (PCI-Express) (rev 01)
> 02:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac Wireless Network Adapter
> )
>
> Googling has not helped me figure out how to get propper bandwidth.
> All of the search results were about wan links, not about wlan links.
>
> What should I look at to diagnose this?
>
> -JimC


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
