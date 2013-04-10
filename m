Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:56095 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3DJLIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 07:08:25 -0400
Received: by mail-ie0-f178.google.com with SMTP id bn7so329310ieb.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 04:08:24 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 10 Apr 2013 13:08:24 +0200
Message-ID: <CAFSJ42Y_ZgXEbub0_AFsGWY=UCofYRJ1=eqDvySuO1p+pu0ahw@mail.gmail.com> (sfid-20130410_130829_183634_A3B7486B)
Subject: Build warning: net/wireless/reg.c:244:2: warning: the comparison will
 always evaluate as 'true'
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

While trying to build latest compat-drivers with old kernel version
3.0.60 build generates a warning:

/compat-drivers/net/wireless/reg.c:244:2: warning: the comparison will
always evaluate as 'true' for the address of 'core_request_world' will
never be NULL [-Waddress]

As a workaround this warning can be suppressed with pragma:
#pragma GCC diagnostic ignored "-Waddress"

but it is not a solution. Is it a known bug or maybe somebody has a
solution to this warning? Any suggestion is really appreciated.

--
Best regards,
Eugene
