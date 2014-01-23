Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:42536 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAWJV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 04:21:26 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: zhuyj <zyjzyj2000@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: 802.11a is supported in AP mode or not?
Date: Thu, 23 Jan 2014 09:21:23 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558C39A2@ALA-MBB.corp.ad.wrs.com> (sfid-20140123_102130_758591_7EB2EC38)
References: <52DF947E.40800@gmail.com>
 <CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com>
 <CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>
 <52E0BA40.7090203@gmail.com>
 <CANUX_P05h39mPbhPBhKzVZb+vtyxtfsPMwOcv4UgJR_yJRcXdw@mail.gmail.com>
 <52E0D7D5.6060504@gmail.com>
 <CABPxzYLZO9RDDpVOUTjmNWqVz71S_ufVKWy9UsejfsNGbyCcow@mail.gmail.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C38F6@ALA-MBB.corp.ad.wrs.com>,<CABPxzYLMosYvkhTxq+8WJOwhQuxinSxQ64TeSU+3YgqcjhZa0g@mail.gmail.com>,<DE84205DFC6FCF4A904A2F75D822FABA558C3931@ALA-MBB.corp.ad.wrs.com>,<DE84205DFC6FCF4A904A2F75D822FABA558C3977@ALA-MBB.corp.ad.wrs.com>
In-Reply-To: <DE84205DFC6FCF4A904A2F75D822FABA558C3977@ALA-MBB.corp.ad.wrs.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



So,it that mean: there is no way to fix this problem by modify the kernel and driver codes?

Though #iwconfig wlan0 shows there is modes a ?

iwconfig wlan0
wlan0     IEEE 802.11abgn  ESSID:"IDPDK-169c"
          Mode:Managed  Frequency:2.462 GHz  Access Point: A0:88:B4:1E:16:9C
          Bit Rate=1 Mb/s   Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=60/70  Signal level=-50 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:14   Missed beacon:0


Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Liu, Bopeng [Bopeng.Liu@windriver.com]
Sent: Thursday, January 23, 2014 5:07 PM
To: Krishna Chaitanya
Cc: zhuyj; Emmanuel Grumbach; linux-wireless
Subject: RE: 802.11a is supported in AP mode or not?

By using latest hostapd, version, not works as well.

Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: Krishna Chaitanya [chaitanya.mgit@gmail.com]
Sent: Thursday, January 23, 2014 5:04 PM
To: Liu, Bopeng
Cc: zhuyj; Emmanuel Grumbach; linux-wireless
Subject: Re: 802.11a is supported in AP mode or not?

On Thu, Jan 23, 2014 at 2:29 PM, Liu, Bopeng <Bopeng.Liu@windriver.com> wrote:
> Is there any method to set the 5GHz channels be able?
>
> Please show me the command...:)
No it doesn't work that way, based on regulatory info and HW capability
the framework will decide that.

Lets give it a try with latest hostapd from git and see.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
