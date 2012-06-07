Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:34995 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932119Ab2FGSKh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 14:10:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: =?iso-8859-1?Q?Hans_Kr=F6ner?= <hanskroner@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Thu, 7 Jun 2012 11:10:09 -0700
Subject: RE: mwifiex:Testing AP functionality with hostapd
Message-ID: <477F20668A386D41ADCC57781B1F7043083A7F0979@SC-VEXCH1.marvell.com> (sfid-20120607_201041_187794_579F765F)
References: <loom.20120607T100950-564@post.gmane.org>
In-Reply-To: <loom.20120607T100950-564@post.gmane.org>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hans,

> I wanted to test the new "AP mode" functionality in the mwifiex driver so I
> built a kernel off the wireless-testing tree and hostapd v2.0-devel from git.
> I tried this on a "DreamPlug" that uses the SD8787.
> 
> "Client mode" is working fine, but I can't seem to be able to get "AP mode"
> working. No matter what I do I get this output from hostapd:
 
[...]

> I've tried bringing both mlan0 and uap0 interfaces down/up and different
> combinations of both to no avail. The patches for "AP mode" support mention
> that is has been tested against hostapd v2.0-devel. Is there anything I should
> be aware of when building hostapd? 

The latest hostapd code requires mgmt handlers which we are still working on.
Please checkout the commit id mentioned by Avinash.

> I'm also not sure if I'm running the correct firmware for the SD8787.

[...]

> mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0 (14.57.5.p69)

Please get the latest firmware image (14.66.9.p80) here:

git://git.marvell.com/mwifiex-firmware.git
http://git.marvell.com/?p=mwifiex-firmware.git;a=summary

Thanks,
Bing

