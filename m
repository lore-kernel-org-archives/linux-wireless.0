Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:34785 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933467Ab0BEAME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 19:12:04 -0500
Message-ID: <4B6B624B.2040503@free.fr>
Date: Fri, 05 Feb 2010 01:11:55 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix probe request filtering in IBSS mode
References: <1265319286-21861-1-git-send-email-benoit.papillault@free.fr> <43e72e891002041554r3fea0025kf2c2062b7fd55f0c@mail.gmail.com>
In-Reply-To: <43e72e891002041554r3fea0025kf2c2062b7fd55f0c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez a écrit :
> On Thu, Feb 4, 2010 at 1:34 PM, Benoit Papillault
> <benoit.papillault@free.fr> wrote:
>   
>> We only reply to probe request if either the requested SSID is the
>> broadcast SSID or if the requested SSID matches our own SSID. This
>> latter case was not properly handled since we were replying to different
>> SSID with the same length as our own SSID.
>>
>> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
>>     
>
> Cc: stable@kernel.org it seems?
>
>  Luis
>   
Indeed! Do I need to resend?
Benoit

