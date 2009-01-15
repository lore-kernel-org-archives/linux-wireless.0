Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34295 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZAOJKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 04:10:03 -0500
Received: by bwz14 with SMTP id 14so3050483bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 01:10:00 -0800 (PST)
Message-ID: <41960ccf0901150110l754e5b83sb85d03d43f2927b9@mail.gmail.com> (sfid-20090115_101013_298806_ECAB7BB4)
Date: Thu, 15 Jan 2009 10:10:00 +0100
From: "Lorenzo Nava" <navalorenx@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [b43] opensource firmware
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"Francesco Gringoli" <francesco.gringoli@ing.unibs.it>
In-Reply-To: <496E243F.1080500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com>
	 <496E243F.1080500@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/14 Larry Finger <Larry.Finger@lwfinger.net>:
> Lorenzo Nava wrote:
>
>> Today we have also tested a new firmware version that works with
>> WPA2-personal (both TKIP and CCMP) and WPA2-enterprise (EAP-TTLS)
>> (tested on 4306 and 4318 PCI device). If anybody was interested please
>> try new firmware with encryption and let us know if it works correctly,
>> thanks!
>
> On my BCM4318 (Linksys WPC54G, Ver 3) in a Cardbus format in a
> WPA2-personal encrypted network with AES algorithm, it nearly worked.
> With your firmware, it can scan and authenticate. It even gets an
> DHCP-supplied IP address; however, I get no data through the link. In
> addition, I see lots of PHY TRANSMISSION ERRORS. When I disable
> hardware encryption (nohwcrypt=1), then it works.

Yes, you're right. Actually there are 2 ways to make firmware works:

1) Disable hw crypto with module parameter
2) Remove pcm5.fw from your /lib/firmware/b43 directory

When I run the firmware I never include pcm5.fw file. The only
initvals really necessary are b0g0bsinitvals.fw and b0g0bsinitvals.fw.

cheers

Lorenzo
>
> Great job.
>
> Larry
>
