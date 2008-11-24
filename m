Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:17207 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbYKXWnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 17:43:20 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1181773nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 14:43:18 -0800 (PST)
Message-ID: <492B2E07.9050105@gmail.com> (sfid-20081124_234324_685152_DC9C8B3A)
Date: Mon, 24 Nov 2008 17:43:19 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: wireless-regdb: update regulatory rules for US 2.3-2.4GHz and 5.65-5.925GHz
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The above frequencies are allowed by FCC part 97 to amateur radio 
operator as primary use, this doesn't even cover the secondary and 
tertiary uses, just where amateurs are primary.  Frankly I disagree with 
flat out add this to the US reg domain but we would just add a "97" reg 
domain for licensed users.

This also introduces a new issue in crda of setting not only power 
limits but power limits based on modulation.  It is permitted to use 
DSSS up to 100 watts, however, OFDM is permitted up to 1500 watts.

In all honesty I am not really sure this is a good time to start adding 
this stuff but since thinking about it is exposing flaws in crda I 
figured I would at least mention it.

Thanks,
Rick Farina
