Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:36207 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932413Ab2BBQIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 11:08:40 -0500
Received: by mail-wi0-f175.google.com with SMTP id hq7so2300626wib.20
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 08:08:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F2781B4.9080004@sipsolutions.net>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-9-git-send-email-victorg@ti.com>
	<4F2781B4.9080004@sipsolutions.net>
Date: Thu, 2 Feb 2012 18:08:36 +0200
Message-ID: <CAK80WHZr_VZhJAbfdsWTsf_ZYXrBXhnzT+m3WVBH3Q6fvn1JAA@mail.gmail.com> (sfid-20120202_170844_129828_7E607AF2)
Subject: Re: [RFC 8/9] mac80211: add DFS capabilities flag
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 7:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On 1/26/2012 4:38 AM, Victor Goldenshtein wrote:
>>
>> Add new IEEE80211_HW_SUPPORTS_RADAR_DETECTION attribute which
>> indicates that hw supports radar detection.
>
>
> No need, driver can set the nl80211 flags directly.

ok.


Thanks for the review,
Victor.
