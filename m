Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:53733 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1CVAI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 20:08:26 -0400
Received: by pxi2 with SMTP id 2so1270157pxi.10
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 17:08:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87aagovhsl.fsf@purkki.adurom.net>
References: <AANLkTiniNj9vcYdSBpp+28zMDJEN-=hq40_1zxcrg74J@mail.gmail.com>
	<87aagovhsl.fsf@purkki.adurom.net>
Date: Mon, 21 Mar 2011 17:08:25 -0700
Message-ID: <AANLkTikyir_RtupUoszFOxPKPfPek2qzyE8bbMEcg-=X@mail.gmail.com>
Subject: Re: terminology questions
From: Sean Robinson <seankrobinson@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 21, 2011 at 4:23 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Sean Robinson <seankrobinson@gmail.com> writes:
>
>> What is a station?
>
> You got an answer already. But in principle all devices supporting
> IEEE 802.11 are stations (or STAs) in the standard.
>
>> How does a station relate to an AP?
>
> AP is a station as are all clients.
>
>>  What are the delineations between mac80211/cfg80211/nl80211?
>
> mac80211 is an IEEE 802.11 stack for softmac devices.
>
> cfg80211 is a new (relatively speaking) component for managing
> configuration of IEEE 802.11 devices (used by both mac80211 and
> fullmac device drivers).
>
> nl80211 is a new (again relatively speaking) netlink based user space
> interface (protocol?) for managing IEEE 802.11 devices. cfg80211
> implements the kernel side of this interface. From user space at least
> wpasupplicant and iw use this interface, but in principle any
> application can use it.
>

  Thank you, Kalle.  I have updated the Glossary page with my
interpretation of your answers.

  And, thank you, Daniel.  I downloaded the IEEE doc.  While the
definitions are useful, the chapter 5 overview of how everything is
related was really helpful.

  And I repeat my intent to curate the Glossary for a while.  So, if
anyone else has terms to add or that need a fuller explanation, please
let me know.

-- 
Sean Robinson
WiFi Radar - http://wifi-radar.berlios.de
Python WiFi - http://pythonwifi.wikispot.org
pymnl - http://pymnl.wikispot.org
