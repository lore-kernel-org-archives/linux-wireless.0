Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42096 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759091Ab3BGRin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 12:38:43 -0500
Received: by mail-oa0-f43.google.com with SMTP id l10so3090672oag.16
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2013 09:38:42 -0800 (PST)
Message-ID: <5113E69D.4010209@lwfinger.net> (sfid-20130207_183849_896291_2C6FE617)
Date: Thu, 07 Feb 2013 11:38:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thomas Rosenkranz <tom.rosary@googlemail.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: bugreport upstream: 0bda:819a RTL8188CUS WLAN doesn't work
 out of the box
References: <51045387.2040607@gmail.com> <5112A972.3060109@lwfinger.net> <CAOAX8-np_cY85=qL4TQCS9_d3tvggZTww7Maq1RWcasJsQxngw@mail.gmail.com> <5112EDAA.9050002@lwfinger.net> <CAOAX8-=_D9PncnaCGkfFKBkenxppQ-EksEQk5UwFKtBY+toRaQ@mail.gmail.com> <CAOAX8-nafHZiCYYP2-ApLMKJ-d3HKcbkENeztpPjLKv39EEzig@mail.gmail.com> <CAOAX8-nCRm2S0OX8TeNmZ9HGe0MB8UmA-huWE_QctgDhtFrZEA@mail.gmail.com> <5113D9C0.1080501@gmail.com> <CAOAX8-k28rV4mx3D9U_jLHbVPmphEd0ZsfwPp4TatVxkdts=_w@mail.gmail.com> <CAOAX8-m-nOLtSXAnWGHia8U2qsp_QPnJ-O0cqUy2FWwoLFh-_g@mail.gmail.com> <5113DCC2.3070306@gmail.com> <CAOAX8-kbMaT7ztvA9cJ7JA5YSHz-fWFvtgqJevpsQ=mBzSV96Q@mail.gmail.com>
In-Reply-To: <CAOAX8-kbMaT7ztvA9cJ7JA5YSHz-fWFvtgqJevpsQ=mBzSV96Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2013 11:01 AM, Thomas Rosenkranz wrote:
> I know thats why i wanted to remove it before.
> Sorry I didn't saw the last two commands they were shown as citation.
> Finally rtl8192cu works with the patch

Good. I'll submit a patch adding this USB ID to the standard kernels. I'll also 
send it to you so that you can patch your kernel and do away with the writing of 
new_id.

Larry


