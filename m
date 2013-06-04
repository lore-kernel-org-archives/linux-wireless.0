Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f195.google.com ([209.85.212.195]:58493 "EHLO
	mail-wi0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3FDNdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 09:33:18 -0400
Received: by mail-wi0-f195.google.com with SMTP id hm9so56572wib.10
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jun 2013 06:33:16 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 4 Jun 2013 21:20:26 +0800
Message-ID: <CAB-Tk70FmmfZOaJnWOubcOrP3MyXebTtrY936_4NROmf_76EZw@mail.gmail.com> (sfid-20130604_153322_039655_7E812C87)
Subject: carl9170:5/10 MHz Channel Support on carl9170
From: "C.B. Wang" <wtwangcb@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I want to know if the ar9170 chip support 5/10 mhz channels.The
datasheet says it supports
802.11j,but the carl9170 driver does not provide support.

Also the radio chip ar9104 has tuning range from 2.3-2.5ghz and
4.9-6.1ghz,but the driver
does not provide any support for these super channels.Isn't the ar9170
chip doesn't support
super channel,or the driver does not implement these features?



                    c.b.wang
