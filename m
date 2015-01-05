Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23771 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbbAEK7x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 05:59:53 -0500
From: Avinash Patil <patila@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	"janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>
Date: Mon, 5 Jan 2015 02:58:30 -0800
Subject: RE: [PATCH] cfg80211: check for carrier state only when offchanel
 CAC supported
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A67@SC-VEXCH2.marvell.com> (sfid-20150105_115958_068680_0D7AB1CC)
References: <1419425236-17457-1-git-send-email-patila@marvell.com>,<1420449663.1898.0.camel@sipsolutions.net>
In-Reply-To: <1420449663.1898.0.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Monday, January 05, 2015 2:51 PM
To: Avinash Patil
Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo; janusz.dziedzic@tieto.com
Subject: Re: [PATCH] cfg80211: check for carrier state only when offchanel CAC supported

On Wed, 2014-12-24 at 04:47 -0800, Avinash Patil wrote:

> + * @NL80211_EXT_FEATURE_OFFCHAN_CAC: This device/driver supports
> + * offchannel Channel Availibility Check(CAC).

>as Arend said, please indent (with a tab)

>You're also mis-spelling "availability" :)

>   * @NUM_NL80211_EXT_FEATURES: number of extended features.
>   * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
>   */
>  enum nl80211_ext_feature_index {
>
> +     NL80211_EXT_FEATURE_OFFCHAN_CAC,

>Better add it before rather than after the blank line.

>johannes

Thanks for review, Johannes.
Will send v3 with your comments addressed.

Thanks,
Avinash.

