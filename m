Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:49135 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaAXG0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 01:26:07 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	zhuyj <zyjzyj2000@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: 802.11a is supported in AP mode or not?
Date: Fri, 24 Jan 2014 06:26:01 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558C3FF5@ALA-MBB.corp.ad.wrs.com> (sfid-20140124_072629_710124_49579AA3)
References: <52DF947E.40800@gmail.com>
	<CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>
	<DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com>
	<CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>
	<52E0BA40.7090203@gmail.com>
	<CANUX_P05h39mPbhPBhKzVZb+vtyxtfsPMwOcv4UgJR_yJRcXdw@mail.gmail.com>
	<52E0D7D5.6060504@gmail.com>
	<CABPxzYLZO9RDDpVOUTjmNWqVz71S_ufVKWy9UsejfsNGbyCcow@mail.gmail.com>
	<DE84205DFC6FCF4A904A2F75D822FABA558C38F6@ALA-MBB.corp.ad.wrs.com>
	<CABPxzYLMosYvkhTxq+8WJOwhQuxinSxQ64TeSU+3YgqcjhZa0g@mail.gmail.com>
	<DE84205DFC6FCF4A904A2F75D822FABA558C3931@ALA-MBB.corp.ad.wrs.com>
	<DE84205DFC6FCF4A904A2F75D822FABA558C3977@ALA-MBB.corp.ad.wrs.com>
	<DE84205DFC6FCF4A904A2F75D822FABA558C39A2@ALA-MBB.corp.ad.wrs.com>,<CANUX_P16BOvf9XDH41u8exNAQyyn2dKkPdN3kOBB+9N5Pu8T2Q@mail.gmail.com>
In-Reply-To: <CANUX_P16BOvf9XDH41u8exNAQyyn2dKkPdN3kOBB+9N5Pu8T2Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just check the chip 6205's spec. it said it supports the SoftAP with Mode A, 

but why the AP in mode A can't be used?

Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: Emmanuel Grumbach [egrumbach@gmail.com]
Sent: Thursday, January 23, 2014 5:27 PM
To: Liu, Bopeng
Cc: Krishna Chaitanya; zhuyj; linux-wireless
Subject: Re: 802.11a is supported in AP mode or not?

On Thu, Jan 23, 2014 at 11:21 AM, Liu, Bopeng <Bopeng.Liu@windriver.com> wrote:
>
>
> So,it that mean: there is no way to fix this problem by modify the kernel and driver codes?
Yes

>
> Though #iwconfig wlan0 shows there is modes a ?

In client mode - not in AP mode
>
> iwconfig wlan0
> wlan0     IEEE 802.11abgn  ESSID:"IDPDK-169c"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: A0:88:B4:1E:16:9C
>           Bit Rate=1 Mb/s   Tx-Power=15 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           Link Quality=60/70  Signal level=-50 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:14   Missed beacon:0
>
>
