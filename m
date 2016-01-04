Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34018 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbcADQeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 11:34:19 -0500
Received: by mail-wm0-f53.google.com with SMTP id u188so153603483wmu.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jan 2016 08:34:18 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 4 Jan 2016 17:34:18 +0100
Message-ID: <CANfLQrZt=pmn2OcU2riTzG5gExY8G8zji1HZnQ_1Fcrx2Jb33w@mail.gmail.com> (sfid-20160104_173422_241184_127CC5AC)
Subject: Android with mac80211
From: Gucea Doru <gucea.doru@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello folks,

Is there any Android smartphone that uses the mac80211 framework for
Wi-Fi management (e.g: driver with support for mac80211)?

After searching several hours, the only result that I have is that the
wcn36xx driver [1] can be used on some Android devices. The problem is
that the driver is not yet upstreamed and it does lack a lot of
features.

If this is not the bestplace for asking this question, please link me
to the correct mailing list.

[1] https://github.com/KrasnikovEugene/wcn36xx

Thank you,
Doru
