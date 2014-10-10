Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:58595 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaJJPI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 11:08:56 -0400
Subject: ath10k firmware crash
Date: Fri, 10 Oct 2014 16:46:40 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local> (sfid-20141010_170901_302420_49D6EE6B)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <ath10k@lists.infradead.org>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi all, 

	I'm trying to use ath10k in client mode and AP mode with 2 wireless cards (Ap on one card and client on another card).
	The AP mode work, but the client mode always crash. Please find below the ath10k crash information

[   79.131301] ath10k: hardware name qca988x hw2.0 version 0x4100016c
[   79.149420] ath10k: firmware version: 999.999.0.636
[   79.167248] ath10k: target register Dump Location: 0x0040AC14
[   79.185939] ath10k: target Register Dump
[   79.201804] ath10k: [00]: 0x4100016C 0x00000000 0x009C4521 0x00000000
[   79.220184] ath10k: [04]: 0x009C4521 0x00060330 0x00000019 0x00955A00
[   79.238566] ath10k: [08]: 0x0000D0CE 0x00000000 0x0040CC94 0x00000020
[   79.256945] ath10k: [12]: 0x00000000 0x00000000 0x00958360 0x0095836B
[   79.275327] ath10k: [16]: 0x809A0978 0x0040AD94 0x00439304 0x0040D074
[   79.293706] ath10k: [20]: 0x0000FFFF 0x00000000 0x0041EFB8 0x00000000
[   79.312086] ath10k: [24]: 0x809A0978 0x0040AD94 0x00439304 0x0343389A
[   79.330466] ath10k: [28]: 0x809AD1A2 0x0040ADE4 0x00439304 0x0043F68C
[   79.348845] ath10k: [32]: 0x809B01DA 0x00000000 0x00410110 0x0041937C
[   79.367224] ath10k: [36]: 0x00000000 0x00000000 0x00000000 0x00000000
[   79.385604] ath10k: [40]: 0x00000000 0x00000000 0x00000071 0x00412700
[   79.403984] ath10k: [44]: 0x00439BB8 0x00000000 0x00000000 0x00400000
[   79.422364] ath10k: [48]: 0x809AE0B4 0x0040AE04 0x00400000 0x0043F68C
[   79.440744] ath10k: [52]: 0x00000001 0x00000000 0x004231F0 0x00400000
[   79.459124] ath10k: [56]: 0x809AE17E 0x0040AE44 0x0040FE6C 0x0040D310

	I'm using openwrt, and I have the same problem with/without configuration option "Firmware optimized for sta operation".

	Is it possible to use at the same time on 2 different cards the AP mode and client mode?

Cedric Voncken 

