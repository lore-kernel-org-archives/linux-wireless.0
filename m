Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49973 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab2A0Cq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 21:46:29 -0500
Received: by wics10 with SMTP id s10so890805wic.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 18:46:27 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 26 Jan 2012 21:46:27 -0500
Message-ID: <CALGY4ft1y00caq9xEhMkm4L3jO9pt0NDXYjUO+TLS12w8ZAT5g@mail.gmail.com> (sfid-20120127_034641_702894_2116F3F8)
Subject: iwlwifi regression
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

  I seeing regression in iwlwifi using intel 5300 card. It used to
work fine but after one upgrade is started to fail. Symptom: at some
point card stops transmitting or receiving any data, but still holds
connection. No specific errors in logs. Disconnecting/reconnecting
helps for very short period.
  I was able to track it down and it looks like the problem was
introduced in next-20111222. I.e. next-20111221 is fine, next-20111222
is not (compat-wireless-2011-12-18 is fine, 2011-12-23 is broken).

  I tried to look into diff between next-20111221 and next-20111222
but it looks quite large and I do not really know how to bisect it
further. So I'd appreciate any hint on this.
  I'd be happy to provide any additional information and can try
patches locally.
  Thanks!

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
