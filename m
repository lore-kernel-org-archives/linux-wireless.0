Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from r-mail1.rd.orange.com ([217.108.152.41]:18843 "EHLO
	r-mail1.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3GIKu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 06:50:56 -0400
Message-ID: <51DBEB0C.6040704@Free.fr> (sfid-20130709_125059_472421_53B0A428)
Date: Tue, 09 Jul 2013 12:50:52 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ralink 3290: still lots of misc errors reported by Iwconfig with
 3.10 + HD streaming on WiFi fails
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just bought a HP netbook for my son equipped with this chipset. I 
first tried linux 3.9.7, got WiFi working badly but working. Saw fix for 
TX power in 3.9.9. WiFi became more reliable but still had a lot of  TX, 
and MISC errors reported by iwconfig.  While laptop is now usable for 
internet browsing, trying to play HD tv via XBMC + tvheadend fails 
miserably due to WiFi data rate and WiFi errors while other PC at home 
do play without problems.

Saw the fix in 3.10 for TX errors and indeed the TX errors dropped to 0. 
However, the MISC error count in turn rose (Downloading 
linux-3.10.tar.xz on 3.10 reports 550 misc errors). So there is still 
some problem with this chipset. I know support is experimental but I 
would be glad to test any patchif possible on 3.9.x as on 3.10 I have no 
ATI driver available at the moment and thus HD decoding is out of reach 
anyway.

Using ralink proprietary driver on linux recent kernel and amd64 is a no 
go(does not compile due to API change + lots of INT32/pointers 
conversion)but may be the driver code could shed some light for people 
with adequate knowledge...

Please CC me I'm not subscribed

-- eric
