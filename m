Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:56716 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaAXIEb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 03:04:31 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	zhuyj <zyjzyj2000@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: 802.11a is supported in AP mode or not?
Date: Fri, 24 Jan 2014 05:27:58 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558C3E9D@ALA-MBB.corp.ad.wrs.com> (sfid-20140124_090434_166919_3067D3F7)
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
	<DE84205DFC6FCF4A904A2F75D822FABA558C39A2@ALA-MBB.corp.ad.wrs.com>
	<CANUX_P16BOvf9XDH41u8exNAQyyn2dKkPdN3kOBB+9N5Pu8T2Q@mail.gmail.com>
	<CABPxzYLJwyXA+XZ+nHzoCZrSo99joTfhP7iQUbWMfcw403H_WA@mail.gmail.com>
	<DE84205DFC6FCF4A904A2F75D822FABA558C3A05@ALA-MBB.corp.ad.wrs.com>,<CANUX_P2LODJOk3R+oZ-1LHPJiAS22niV4hW904QAqT-3KYxiTw@mail.gmail.com>
In-Reply-To: <CANUX_P2LODJOk3R+oZ-1LHPJiAS22niV4hW904QAqT-3KYxiTw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just check the chip 6205's spec. it said it supports the SoftAP with Mode A, who can tell me what is the soft AP?


Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: Emmanuel Grumbach [egrumbach@gmail.com]
Sent: Thursday, January 23, 2014 5:49 PM
To: Liu, Bopeng
Cc: Krishna Chaitanya; zhuyj; linux-wireless
Subject: Re: 802.11a is supported in AP mode or not?

On Thu, Jan 23, 2014 at 11:34 AM, Liu, Bopeng <Bopeng.Liu@windriver.com> wrote:
> But very pity, when running on the AP mode:wlan0     IEEE 802.11abgn  is the same....
>
> ~# iwconfig wlan0
> wlan0     IEEE 802.11abgn  Mode:Master  Frequency:2.412 GHz  Tx-Power=15 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Power Management:off
>

cool - just send a patch to fix iwconfig, but this tool is ancient and
I doubt anybody even cares.
