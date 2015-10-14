Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35024 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbJNV4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 17:56:54 -0400
Received: by qgt47 with SMTP id 47so55762506qgt.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 14:56:53 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 14 Oct 2015 17:56:53 -0400
Message-ID: <CAP-AUyiyCMuJ51gGRyJSWGkFFe78Q-y8skSn1MPtyys=nNTNXw@mail.gmail.com> (sfid-20151014_235657_542150_EC04050C)
Subject: MIMO Transmit
From: Brandon Enochs <enochs.brandon@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does anyone know how to perform raw transmit at an arbitrary MIMO data
rate?  It seems to work great for all the 802.11a/b/g rates by masking
off all but one rate with nl80211, but I can't seem to figure it out
for 802.11n for any HT enabled channel bandwidths.

Any help is greatly appreciated,
Brandon
