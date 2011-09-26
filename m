Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42756 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab1IZOHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 10:07:18 -0400
Received: by eya28 with SMTP id 28so3618033eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 07:07:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
Date: Mon, 26 Sep 2011 16:07:17 +0200
Message-ID: <CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com> (sfid-20110926_160722_409164_E6DB8C9E)
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM Fritz!Box
 (7390)" incompatible
From: Henrik Friedrichsen <hrkfdn@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One more thing I have noticed:

This message is only being printed when I connect to the AP, that I
have problems with:

Sep 26 07:05:03 dharma kernel: [ 2213.379252] iwlagn 0000:03:00.0: Tx
aggregation enabled on ra = xx:xx:xx:xx:xx:xx tid = 0

On the APs that work fine, it DOES NOT get printed.
