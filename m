Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41993 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3FALB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 07:01:57 -0400
Received: by mail-pd0-f182.google.com with SMTP id g10so3479073pdj.27
        for <linux-wireless@vger.kernel.org>; Sat, 01 Jun 2013 04:01:56 -0700 (PDT)
Received: from gmail.com ([203.86.46.201])
        by mx.google.com with ESMTPSA id rn7sm50873292pbc.12.2013.06.01.04.01.54
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Sat, 01 Jun 2013 04:01:56 -0700 (PDT)
Date: Sat, 1 Jun 2013 19:01:50 +0800
From: Huawei Yang <harvey.huawei.yang@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: BK, VI, VO tx queue stopped unexpectedly
Message-ID: <20130601110149.GA6504@gmail.com> (sfid-20130601_130217_716513_33BCA89A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys

I am writing a nl80211/cfg80211 driver for my wifi chip. I am testing my chip under the AP mode with hostapd. I use the kernel 3.0. I start the AP and check that all four tx queues are start, then I start a udp stream of BE from Ap to the station. After that I find other three tx queues stopped. I am sure that my driver dose not stop them. Is this a kernel machinesm ? 

Thanks  
