Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:41230 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201AbYGTCzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 22:55:18 -0400
Message-ID: <4882A910.4040408@lwfinger.net> (sfid-20080720_045530_211672_F10C57B7)
Date: Sat, 19 Jul 2008 21:55:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Improve wireless statistics for RTL8187B
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>	 <200807182142.59921.herton@mandriva.com.br>	 <48816A43.1050903@lwfinger.net> <3ace41890807191739t5969f38au170e4b73a3d0b7de@mail.gmail.com>
In-Reply-To: <3ace41890807191739t5969f38au170e4b73a3d0b7de@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> I am on x86_64 and I am on a similar situation - I am using the
> rawhide kernels from:
> http://koji.fedoraproject.org/koji/packageinfo?packageID=8
> and the last one that worked for me is kernel-2.6.25.11-92.fc9 - something in
> kernel-2.6.25.11-93.fc9 broke connectivity. Apparently the difference
> is this set of changes:
> http://marc.info/?l=linux-wireless&m=121606436000705&w=2
> 
> I just don't feel like mentioning it earlier because I had mistakenly
> complained about Herton's
> last patch and I don't want to make the same mistake - and I did test
> it. Beside Herton's
>  ANAPARAM*_OFF patch (which I don't think is the source of the
> problem), there is
> only one other "rtl8187: Fixed section mismatch in rtl8187_dev.c"
> change - but that's is also
> obviously right, and besides, its nature shouldn't affect association
> anyway; but there is
> a lot of mac80211 changes elsewhere, and I wonder.
> 
> My symptom is that I can authenticate and associate (apparently,
> according to dmesg)
> but cannot get an ip address via dhcp. I have tried and just alternate
> between the two kernels,
> identical steps, etc and one works and the other doesn't.
> 

Curious. According to the git log, my copy of the wireless-testing tree has all 
those patches installed. There must be some really obscure configuration 
difference, or the rawhide kernel has some unexpected difference with the wl 
kernels.

Larry

