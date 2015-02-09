Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21073 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbbBIHQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 02:16:13 -0500
From: "Nagarajan, Ashok Raj" <arnagara@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
Subject: RE: [PATCH] cfg80211: add debugfs VHT80 allow map
Date: Mon, 9 Feb 2015 07:16:02 +0000
Message-ID: <1423466162219.33842@qti.qualcomm.com> (sfid-20150209_081621_814091_E7DED96D)
References: <1423204546-22872-1-git-send-email-arnagara@qti.qualcomm.com>,<1423249860.2037.28.camel@sipsolutions.net>
In-Reply-To: <1423249860.2037.28.camel@sipsolutions.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I see your point here. I will upload one patch for printing this info from iw.

I will also write another patch for removing HT40 one?

Thanks,
Ashok
________________________________________
From: Johannes Berg <johannes@sipsolutions.net>
Sent: Saturday, February 7, 2015 12:41 AM
To: Nagarajan, Ashok Raj
Cc: linux-wireless@vger.kernel.org; Manoharan, Rajkumar; Thiagarajan, Vasanthakumar
Subject: Re: [PATCH] cfg80211: add debugfs VHT80 allow map

On Fri, 2015-02-06 at 12:05 +0530, Ashok Raj Nagarajan wrote:
> Here is a output of this debugfs entry
>
> root@OpenWrt:/# cat /sys/kernel/debug/ieee80211/phy0/vht80allow_map
> 2412 VHT80 N

I'm not sure I see much point in this, in fact we could remove the HT40
one?

We expose this data to userspace, so you could change 'iw' to print it
when dumping the list of channels in 'iw list' or similar.

johannes

