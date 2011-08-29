Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H2GDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 02:03:22 -0400
Subject: Re: =?UTF-8?Q?=E7=AD=94=E5=A4=8D=3A?= [RFC] mac80211: Adhoc
 WPA-NONE packets lost by mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?=E6=9D=8E=E6=9C=9D=E6=98=8E?=
	<chaoming_li@realsil.com.cn>
Cc: linville@tuxdriver.com, 'Larry Finger' <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	=?UTF-8?Q?=27=E7=86=8A=E5=85=89=E5=AE=89=27?=
	<guangan_xiong@realsil.com.cn>
In-Reply-To: <E3ED66158B154F2592986A66BBFF90F6@realsil.com.cn>
References: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
	 <1314049818-21839-6-git-send-email-Larry.Finger@lwfinger.net>
	 <F5749057C8FE46CD88E05545135626BB@realsil.com.cn>
	 (sfid-20110823_115916_036908_E0E26086) <1314153017.4573.1.camel@jlt3.sipsolutions.net>
	 <E3ED66158B154F2592986A66BBFF90F6@realsil.com.cn>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 08:03:14 +0200
Message-ID: <1314597794.4562.0.camel@jlt3.sipsolutions.net> (sfid-20110829_080325_036133_D59E3E43)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-29 at 09:45 +0800, 李朝明 wrote:

> 1)  I found RSN IBSS in Mac80211 code, but I don't kown how to use it.
>       Is there any document that give a explaination of how to use it.

Just use wpa_supplicant (need fairly new git version)

> 2) I can not find RSN IBSS in IEEE80211 spec. Does it only realize in
> Mac80211 driver.
>      How Can I link with other platform's IBSS like windows or linux which
> is not based
>      on Mac80211.

Look again :)

johannes

