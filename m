Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vps.qorvus.com ([67.213.217.156]:35062 "EHLO vps.qorvus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbZKQXjP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 18:39:15 -0500
Message-ID: <7C9BF2FB3F6D47238EB6BC9B4441A996@qlaptop2>
Reply-To: "Tom Sharples" <tsharples@qorvus.com>
From: "Tom Sharples" <tsharples@qorvus.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"David Acker" <dacker@roinet.com>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	<madwifi-users@lists.sourceforge.net>,
	"Andrey Yurovsky" <andrey@cozybit.com>,
	<madwifi-devel@lists.sourceforge.net>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de> <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com> <4B02DFF4.1060509@roinet.com><45e8e6c40911171257m7c687380k6e6e2677fd11f851@mail.gmail.com> <43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com> <4B03193E.2080304@roinet.com><43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com> <4B031B48.1090105@roinet.com><43e72e890911171404x1a46d07alb54946768d0f9cf5@mail.gmail.com> <4B032390.3080501@roinet.com> <43e72e890911171439q74f30bc2t3e6f4ada19a85594@mail.gmail.com>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
Date: Tue, 17 Nov 2009 15:39:14 -0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>
>> There are several miniPCI
>> based radios that require half or quarter width channels on some 
>> channels.
>
> That *require* this?
>
>> For example, the Ubiquiti XR7 requires quarter width channels on two of 
>> its
>> four available channels.
>
> Regulatory wise? What's the restriction based on?
>
>> The XR9 requires half width channels on two if its
>> four available channels.
>
> Same here, what's the restriction based on?
>
On 900 and the 4.9 Ghz public safety bands, the half or quarter channels are 
required if you want to:

(a) Support multiple non-overlapping links within the legally allocated 
bandwidth. For example, within 900 Mhz there is only 25 Mhz total available, 
and only two 20-mhz channels defined (which, of course, overlap) so really 
you've only got one. With 5 Mhz channels, you can operate legally near the 
edge of the band without interfering with other 900 Mhz links, or 
transmitting outside of the FCC allocated band.

(b) Operate legally and efficiently in the 4.9 Ghz public-safety band. The 
upper and lower three channels defined by the FCC are 5Mhz and 10Mhz. 20 Mhz 
operation there would violate the allocated band edges.

(b) Be compatible with other company's products that use these channels, 
e.g. Proxim, Cisco, Ubiquiti, etc.

On 2.4 and 5.8 half and quarter aren't a legal requirement, but they 
certainly are necessary for efficient operation!

Tom S. 

