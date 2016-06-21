Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34815 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbcFUG3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 02:29:40 -0400
Received: by mail-pa0-f66.google.com with SMTP id us13so636167pab.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2016 23:28:13 -0700 (PDT)
Subject: Re: [PATCH] mac80211: Encrypt "Group addressed privacy" action frames
To: Jouni Malinen <j@w1.fi>
References: <1465969112-2814-1-git-send-email-masashi.honma@gmail.com>
 <20160618091116.GA2972@w1.fi> <57673E10.7070706@gmail.com>
 <20160620212529.GA19076@w1.fi>
Cc: linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <5768DBB6.2060501@gmail.com> (sfid-20160621_082947_863514_3F673639)
Date: Tue, 21 Jun 2016 15:16:22 +0900
MIME-Version: 1.0
In-Reply-To: <20160620212529.GA19076@w1.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年06月21日 06:25, Jouni Malinen wrote:
> Do we really want that?

Sorry, I mis-understood your previous massage.
I have thought you required backward compatibility.
Ok, I will remove backward compatibility code.


 > What about RX side?

Previously, MGTK and IGTK was identical key.
Now new wpa_supplicant can provide correct IGTK.
(Because of your great works !)
I have tested with new IGTK, RX side can work without
modification.

I will send new patch.
The patch move ieee80211_is_group_privacy_action()
to appropriate file and fix a bug of skip_hw flag.


