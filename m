Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp137.mail.ukl.yahoo.com ([77.238.184.68]:32162 "HELO
	smtp137.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754203Ab0G2UwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 16:52:24 -0400
Message-ID: <4C51EA06.3010905@users.sourceforge.net>
Date: Thu, 29 Jul 2010 21:52:22 +0100
From: Hin-Tak Leung <htl10@users.sourceforge.net>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Kirill Zut <kirill.zut@promwad.com>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [PATCH 2.6.34] rtl8187: ad-hoc mode support
References: <201007291835.46159.kirill.zut@promwad.com> <20100729180426.GC2424@tuxdriver.com> <4C51D096.7090607@lwfinger.net>
In-Reply-To: <4C51D096.7090607@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> On 07/29/2010 01:04 PM, John W. Linville wrote:
>> Don't you need something to make it beacon?
> 
> Indeed he does. This code allows the user to set ad-hoc mode, but I could not
> establish a connection. The setup that I used worked for a b43 - b43 link, but
> failed if either end used rtl8187. NACK.

I supposed I need to withdrawn my "Ached-by:" - I was using it in the minimal 
sense of "I have seen the patch and aware of its existence".

Is the beacon code driver-specific, or is it back to my older question, some 
part of mac80211 need to have some generic support for it? or both? My 
impression is that master mode for mac80211-based drivers - if it is ever going 
to happen - requires some substantial changes to both mac80211 and hostapd and 
is not happening any time soon.

OTOH, I have the impression that the windows driver claims to support Ad-Hoc 
mode but I could be wrong - it has been a long time since I looked at the 
options and choices under windows.

Hin-Tak
