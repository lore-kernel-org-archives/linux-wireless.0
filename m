Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34738 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaILD5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 23:57:49 -0400
Received: by mail-pd0-f172.google.com with SMTP id v10so307908pde.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 20:57:48 -0700 (PDT)
Received: from [147.46.243.214] ([147.46.243.214])
        by mx.google.com with ESMTPSA id wc5sm2578789pab.2.2014.09.11.20.57.47
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 11 Sep 2014 20:57:47 -0700 (PDT)
Date: Fri, 12 Sep 2014 12:57:44 +0900
From: Okhwan Lee <ohlee@mwnl.snu.ac.kr>
To: linux-wireless@vger.kernel.org
Message-ID: <013176138105415386E2ECF0674E546E@mwnl.snu.ac.kr> (sfid-20140912_055752_567486_F3A3D659)
Subject: Set channel (freq) and bandwidth (BW) using iw command
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,  

I have a simple problem (?), but I cannot find any answer in google and wireless.kerner.org.  
I use 3.16.1 kernel/backport version with ath10k/QCA9880.

I want to handle freq/BW to test its performance.  
When I change center frequency and BW by using iw command, linux reports “command failed: Device or resource busy (-16)” as follows.

$ modprobe ath10k_pci
$ iw wlan0 set channel 36 HT20
command failed: Device or resource busy (-16)
$ iw wlan0 set freq 5180 40 5190
command failed: Device or resource busy (-16)
$ iw wlan0 set freq 5180 80 5210
command failed: Device or resource busy (-16)



Curiously if anyone else has solution for this problem?

Thank you.  

--
Okhwan Lee

