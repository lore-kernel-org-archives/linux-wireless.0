Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:48936 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaAWJtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 04:49:16 -0500
Received: by mail-la0-f53.google.com with SMTP id e16so1234888lan.40
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 01:49:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <DE84205DFC6FCF4A904A2F75D822FABA558C3A05@ALA-MBB.corp.ad.wrs.com>
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
	<DE84205DFC6FCF4A904A2F75D822FABA558C3A05@ALA-MBB.corp.ad.wrs.com>
Date: Thu, 23 Jan 2014 11:49:14 +0200
Message-ID: <CANUX_P2LODJOk3R+oZ-1LHPJiAS22niV4hW904QAqT-3KYxiTw@mail.gmail.com> (sfid-20140123_104921_105974_6FBE7F4C)
Subject: Re: 802.11a is supported in AP mode or not?
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	zhuyj <zyjzyj2000@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
