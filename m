Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53634 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaI0ISy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 04:18:54 -0400
Received: by mail-pd0-f176.google.com with SMTP id fp1so1288795pdb.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Sep 2014 01:18:53 -0700 (PDT)
References: <509C5E93-4D6C-4CCE-A4F6-BA1CEC80AB98@gmail.com> <CAA2SeNKdOBTPnkz2y=WUFqa1sSUmxeMwDCHaT50TwL0O0uJfgQ@mail.gmail.com> <00852C2A-209F-48A8-9F46-2F2520CEF7EE@gmail.com> <1411742131.27290.1.camel@dcbw.local>
In-Reply-To: <1411742131.27290.1.camel@dcbw.local>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=utf-8
Message-Id: <450E9BCC-651A-4ECF-8185-FCF5E7FD32A9@gmail.com> (sfid-20140927_101900_285186_AE060751)
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
From: jammy <benxuelan0402@gmail.com>
Subject: Re: how can we fast roaming between multi-aps
Date: Sat, 27 Sep 2014 16:18:45 +0800
To: Dan Williams <dcbw@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi DAN，
1，Are all the SSIDs the same?
A：yes，SSIDs are same.
2，What kind of authentication?  WPA Enterprise/802.1x?  What EAP methods?
A：there are no authentication，and no EAP methods
3，Is pre-authentication enabled on the network and in the client?
A：how to enable pre-authentication？My linux kernel is build by OpenWRT.
4，Is background scanning enabled in wpa_supplicant, and if so what is the interval?
A：How to enable the background scanning in wpa_supplicant？

thanks.
from jammy's iPhone