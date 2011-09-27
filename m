Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44536 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1I0W1C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 18:27:02 -0400
Received: by eya28 with SMTP id 28so5154483eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 15:27:00 -0700 (PDT)
Message-ID: <4E824D75.1070509@gmail.com> (sfid-20110928_002715_174279_9C87447D)
Date: Wed, 28 Sep 2011 00:25:57 +0200
From: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: 'Chaoming_Li' <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: =?UTF-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogUlRMODE5MlNFIGFuZCA=?=
 =?UTF-8?B?ODAyLjExbiBwcm9ibGVt?=
References: <4E77AECF.7090001@gmail.com> <4E820130.7080801@gmail.com> <4E823976.2090407@lwfinger.net>
In-Reply-To: <4E823976.2090407@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2011 11:00 PM, Larry Finger wrote:
> I have to go now, but if no one describes what we are seeing, I'll
> review the 802.11n specs and get back to you tomorrow.
>
> Larry
I've taken a quick peek at the specs, and I'm afraid I can't be of any
help there (I found out — again — I have great respect for you guys for
reading those documents!). However, something just dawned on me, and I'm
not sure if it is at all relevant here, but somehow, my NIC seems to be
getting all kinds of different MAC addresses assigned (apparently
randomly). I just checked my "persistent net" udev rules file (mind you,
this file is automatically amended whenever a new NIC appears on my
system), and there are 26(!) different rules for just my wireless
interface, all with different MAC addresses.
As you may have noticed from my dump of the association process, the MAC
address in use is one with a vendor ID for some "Azurewave" interface.
There are quite a few in the rules file for Realtek interfaces, but the
one I mostly get is for an Azurewave vendor ID.

I just tried setting a different MAC address (using ifconfig wlan0 hw
ether 00:e0:4c:81:82:58) however it didn't change anything about my no
802.11n link situation (as I expected). So perhaps this little tidbit
should be ignored for now.

I just thought I'd let you know, in case this isn't a known problem.

Regards,
Stefan Zwanenburg
