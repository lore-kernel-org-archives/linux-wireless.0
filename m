Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:22304 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYDTLCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 07:02:18 -0400
Received: by fk-out-0910.google.com with SMTP id 19so1684913fkr.5
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2008 04:02:16 -0700 (PDT)
Message-ID: <3efd34cc0804200402k4b18dbd8i37771d9c547d880b@mail.gmail.com> (sfid-20080420_120221_999661_E99D7255)
Date: Sun, 20 Apr 2008 13:02:15 +0200
From: "bert hubert" <bert.hubert@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: nl80211: state of mac80211 and hostapd ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 19, 2008 at 11:44 PM, bert hubert <bert.hubert@gmail.com> wrote:
>  I've trawled the web and found Johannes Berg's patches, but they
>  appear to indicate that recent hostap & linux kernels don't need any
>  patches.
>
>  Am I trying to do something that can't work? Or do I need patches? I'm
>  more than willing to patch & test.

Ok, I've made a lot of progress. I now run the wireless-2.6.26 tree
and the hostapd git tree, and use the 'nl80211' driver of hostapd.

This does get further, but only succeeds in killing my wireless
connection and dumping core. Yet it feels like progress!

Can you tell me if this is expected to work? Or what trees do I need?

Thanks!
