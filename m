Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39166 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3HOFMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 01:12:05 -0400
Received: by mail-pa0-f52.google.com with SMTP id kq13so401799pab.25
        for <linux-wireless@vger.kernel.org>; Wed, 14 Aug 2013 22:12:04 -0700 (PDT)
Received: from [0.0.0.0] ([210.48.94.225])
        by mx.google.com with ESMTPSA id ia5sm13817279pbc.42.2013.08.14.22.12.02
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 14 Aug 2013 22:12:03 -0700 (PDT)
Message-ID: <520C631F.6010806@gna.org> (sfid-20130815_071230_086833_924D6F0A)
Date: Thu, 15 Aug 2013 17:11:59 +1200
From: Christian Gagneraud <chgans@gna.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Switching band of a dual-band WiFi device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

I am using a TP-Link TL-WDN3200 on a ubuntu 13.04 (kernel 
3.8.0-27-generic), and I have install relevant modules with 
backports-3.11-rc3-1.

I would like to switch my WiFi stick to 5GHz, I tried iwconfig wlan0 
freq 5G, but I get ENOTSUPP.
Is the freq settings suppose to handle this 2.4 vs 5GHz band or is it 
only for selecting channel frequency within a given band?

Does linux-wireless provides a way for selecting 2.4 or 5GHz band?

"iw phy phy11 info" tells me that in band 2, all the frequencies are 
disabled except:
                         * 5745 MHz [149] (30.0 dBm)
                         * 5755 MHz [151] (30.0 dBm)
                         * 5765 MHz [153] (30.0 dBm)
                         * 5775 MHz [155] (30.0 dBm)
                         * 5785 MHz [157] (30.0 dBm)
                         * 5795 MHz [159] (30.0 dBm)
                         * 5805 MHz [161] (30.0 dBm)
                         * 5825 MHz [165] (30.0 dBm)

As well, my understanding of WiFi might be a bit limited but, does a 
dual-band WiFi device provides 2.4 and 5GHz services at the same time or 
do I need to select one or the other myself? Or maybe I can just 
enable/disable them manually (and separately)?

Hope someone can shed some light at this.

Regards,
Chris
