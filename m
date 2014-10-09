Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53015 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaJIOqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 10:46:36 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi2so2007879wib.14
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 07:46:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412864474.1828.51.camel@jlt4.sipsolutions.net>
References: <1410111140-4340-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1410111140-4340-3-git-send-email-lorenzo.bianconi83@gmail.com>
	<1412864474.1828.51.camel@jlt4.sipsolutions.net>
Date: Thu, 9 Oct 2014 16:46:35 +0200
Message-ID: <CAA2SeNLkf5RZsSYjYPpU=E0hHhe2c3G=cbUpy=gfp0kfwDRviQ@mail.gmail.com> (sfid-20141009_164639_889695_7293224F)
Subject: Re: [PATCHv3 2/2] iw: add auto parameter to set distance command
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sun, 2014-09-07 at 19:32 +0200, Lorenzo Bianconi wrote:
>> Add auto parameter to set distance command in order to enable ACK timeout
>> estimation algorithm (dynack). Dynack is automatically disabled setting valid
>> value for coverage class. Currently dynack is supported just by ath9k
>>
>> This patch is based on "configure dynack through mac80211/cfg80211 stack"
>> patchset sent on linux-wireless
>
> Applied.
>
>>  nl80211.h | 12 ++++++++++++
>
> Somehow you also changed nl80211.h here - you shouldn't do that at all
> really :) I will deal with the updates of that file for iw.

I added NL80211_ATTR_WIPHY_DYN_ACK flag attribute to nl80211_attrs
enumeration and NL80211_FEATURE_ACKTO_ESTIMATION flag attribute to
nl80211_feature_flags. I should not? Should I use a different patch?

>
> johannes
>

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
