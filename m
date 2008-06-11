Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:55107 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862AbYFKVag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:30:36 -0400
Message-ID: <48504417.7020803@lwfinger.net> (sfid-20080611_233039_452301_0F65E596)
Date: Wed, 11 Jun 2008 16:31:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: Pavel Roskin <proski@gnu.org>, Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Broadcom's Hybrid Driver
References: <48500F14.8070300@canonical.com> <200806112047.00854.mb@bu3sch.de>	 <1213213666.19106.12.camel@dv> <69e28c910806111326j6922905fq1f67201ab4ce298f@mail.gmail.com>
In-Reply-To: <69e28c910806111326j6922905fq1f67201ab4ce298f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have two ideas about what Broadcom is doing.

The b/g device with an ID of 0x4315 and an LP-PHY is the one that HP 
has been shipping in many laptops for the past few months. Perhaps HP 
wants to offer Linux on those computers, but doesn't want to use 
ndiswrapper for wireless access. HP might have enough clout to get 
Broadcom to budge a little on the subject of Linux.

It is also possible that they want to stifle our RE efforts. The 
license accompanying the binary blob states:

"2.6.    No Other Rights Granted; Restrictions.  Apart from the 
license rights expressly set forth in this Agreement, Broadcom does 
not grant and Licensee does not receive any ownership right, title or 
interest nor any security interest or other interest in any 
intellectual property rights relating to the Software, nor in any copy 
of any part of the foregoing.

Licensee shall not (i) use, license, sell or otherwise distribute the 
Software except as provided in this Agreement, (ii) attempt to reverse 
engineer, decompile or disassemble any portion of the Software; or 
(iii) use the Software or other material in violation of any 
applicable law or regulation, including but not limited to any 
regulatory agency, such as FCC, rules."

Given some of the other parts of the license relating to penalties, 
etc., anyone trying to RE this code could be in a heap of trouble.

Larry
