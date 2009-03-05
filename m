Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:63026 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZCEWVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 17:21:17 -0500
Received: by fxm24 with SMTP id 24so145593fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 14:21:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49B02425.5030005@candelatech.com>
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
	 <4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com>
	 <20090304232625.cc47eb46.cjsthompson@gmail.com>
	 <4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
	 <49AF077D.2020408@erley.org> <1236253402.31456.8.camel@localhost>
	 <041a41424b1a9851b471a7a3b794dc47@127.0.0.1>
	 <49B02425.5030005@candelatech.com>
Date: Thu, 5 Mar 2009 23:21:13 +0100
Message-ID: <69e28c910903051421x6bced2c7k3df7ea880ab64c5a@mail.gmail.com> (sfid-20090305_232120_946138_490D50A5)
Subject: Re: ath5k master (AP) mode
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: pat-lkml@erley.org, Dan Williams <dcbw@redhat.com>,
	Alexey Yudichev <ayudichev@yahoo.co.uk>,
	"Christoph .J Thompson" <cjsthompson@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 5, 2009 at 8:12 PM, Ben Greear <greearb@candelatech.com> wr=
ote:
> pat-lkml@erley.org wrote:
>
>>>> I don't know if it's intended, or just not implemented, but iwconf=
ig
>>>> <iface> mode master
>>>> won't work with mac80211 drivers. =A0Hostapd knows how to set mast=
er mode
>>>> on it's own.
>>>
>>> Hostapd needs to be used for master mode in *any* case. =A0So yes, =
its
>>> intended that you need hostapd for master mode with mac80211 driver=
s.
>>> Just switching the card to master mode simply won't work, because
>>> there's oh-so-much-more setup required in addition to that, which
>>> hostapd knows how to do.
>>>
>>> Dan
>>
>> Thanks for confirming this. =A0It was what I understood to be the ca=
se, and
>> what experimentation had shown, but I was not sure if it was by desi=
gn, or
>> just not implemented yet.
>
> Seems like iwconfig should have a more useful error message,
> telling users to use hostapd for this particular driver,
> instead of just a generic error...
>
> Ben
>

I think that would need a new Wireless Extensions feature, and WExt is
closed for new features, as we are transitioning to cfg80211.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
