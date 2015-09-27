Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34247 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbbI0TKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 15:10:36 -0400
Received: by wicfx3 with SMTP id fx3so78476758wic.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2015 12:10:35 -0700 (PDT)
From: =?utf-8?Q?Karl_M=C3=B6ller?= <karl@excors.net>
Content-Type: text/plain; charset=utf-8
Subject: wireless-regdb: Update regulatory rules for South Africa (ZA) on 5GHz
Date: Sun, 27 Sep 2015 21:10:30 +0200
Message-Id: <9BEBB87E-EA6D-4219-ADC5-40C1E19DA5DA@excors.net> (sfid-20150927_211049_188660_E7BB095C)
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
To: seth.forshee@canonical.com
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2087\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I hope I am doing this the right way (following the Plain English approach and not a git patch…). 
I don’t think the current frequency bands and power limits for ZA are correct. 

My sources are the following documents published this year:

http://www.ellipsis.co.za/wp-content/uploads/2013/10/Guide-to-commonly-used-licence-exempt-frequency-bands-April-2015.pdf

Specifically page 74 of http://www.ellipsis.co.za/wp-content/uploads/2014/12/Radio-Frequency-Spectrum-Regulations-2015.pdf

The bands don’t quite match up and DFS/TPC is (apparently) not required for 5470 - 5725. More importantly, the max transmitted power
seems to be 1W/30dBm e.i.r.p and not 27dBm.  I would submit a complete patch, but I am not sure if the 5725 - 5875 band should be part of it…


Regards
Karl