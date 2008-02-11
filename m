Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:6154 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYBKW1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 17:27:05 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1323415nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2008 14:27:03 -0800 (PST)
Message-ID: <57314e840802111427i7e8d00capbe430727faff78a1@mail.gmail.com> (sfid-20080211_222711_498539_98B9B630)
Date: Tue, 12 Feb 2008 00:27:03 +0200
From: "Budhee Jamaich" <budheej@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: madwifi is not fully open source
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I read at linuxwireless.org that "madwifi is not fully open source".

If I understand correctly, this is because they put the radio-related code
in a binary module, to meet regulatory requirements.

If so, all the other drivers, which are not marked as "not fully open source",
did release their RF code as open source ? How could that be ?
Wouldn't they have regulatory problems ?

What should a new vendor, planning to write a driver, do ? Open Source
everything, and expect legal issues, or release RF code as binary-only ?

Thanks!!
Budhee
