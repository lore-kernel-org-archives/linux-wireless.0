Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34703 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab1ELOLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:11:50 -0400
Received: by ewy4 with SMTP id 4so434664ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 07:11:49 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 May 2011 22:11:48 +0800
Message-ID: <BANLkTi=W3TOyYAVquPLxyQHXkFdQBa4mhQ@mail.gmail.com> (sfid-20110512_161153_819552_FC08D5B4)
Subject: Get wireless network card or check whether an interface is a wireless card
From: Chin Shi Hong <cshong87@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

My application must display only wireless (802.11) network interface
card. Currently, by using some ioctl calls and ifreq structure, my
application currently can detect any network interface. But, I only
want my application to detect wireless network interface card.

What are the ioctl calls or c/c++ codes to do this?

Regards,
