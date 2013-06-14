Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58718 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab3FNSii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 14:38:38 -0400
Received: by mail-pb0-f50.google.com with SMTP id wz7so820676pbc.23
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jun 2013 11:38:38 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Jun 2013 14:38:37 -0400
Message-ID: <CA+7oygeJGfXS2OmGath8LO-ag_aD6mOzdS+0gNS1FqHrgyntFw@mail.gmail.com> (sfid-20130614_203910_081146_51C83413)
Subject: equivalent of AR_DIAG_FORCE_RX_CLEAR on rt2x00?
From: George Nychis <gnychis@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I have carrier sense (both physical and virtual) disabled on an
ath9k_htc card using AR_DIAG_FORCE_RX_CLEAR and
AR_DIAG_IGNORE_VIRT_CS.   I was hoping to do the same thing with the
rt2x00.

I scoured through rt2800.h but didn't see any relevant registers.  It
also seems like the rt2x00 datasheets are private.  The only thing I
can find is access to CWmin/CWmax, which might be able to give me
similar behavior (but, probably not if it behaves like the Atheros
cards).  RX_BUSY seems to only be relevant for counting channel busy
time?

If anyone knows of anything, I'd appreciate it!

Thanks,
George
