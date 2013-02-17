Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:19359 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab3BQIcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2013 03:32:11 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression caused by commit df88129
Date: Sun, 17 Feb 2013 08:32:09 +0000
Message-ID: <8887AA04B7EC49479420AE48C5F94A93017ABCAD@NASANEXD02D.na.qualcomm.com> (sfid-20130217_093220_938752_56B9E81C)
In-Reply-To: <51207925.5040702@lwfinger.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2/17/13 8:31 AM, "Larry Finger" <Larry.Finger@lwfinger.net> wrote:

>A recent pull of the wireless-testing tree caused my wireless to break.
>The
>wireless devices can authenticate and associate as follows:

>wlan0: RX AssocResp from c0:3f:0e:be:2b:44 (capab=0x411 status=0 aid=3)
>wlan0: associated
>IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)

Which wpa_supplicant version are you using here? I'm assuming this is with
WPA2.

It sounds like the AP STA entry does not get authorized properly. I did see
some issues when working on the patch, but fixed those. The version that
was
sent out should have worked fine since I did manage to complete TDLS setup
with it (i.e., send and receive frames through the AP to another STA).

I will be flying for the rest of Sunday, so may not be able to do much
about this before Monday.

- Jouni

