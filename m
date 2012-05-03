Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48342 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751436Ab2ECRKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 13:10:30 -0400
Received: by ghrr11 with SMTP id r11so1976941ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 10:10:30 -0700 (PDT)
Message-ID: <4FA2BC00.9020804@lwfinger.net> (sfid-20120503_191034_422656_DAC1E22C)
Date: Thu, 03 May 2012 12:10:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/9] rtlwifi: avoid race registering with mac80211
References: <4FA212D9.5020602@gtri.gatech.edu> <4FA21339.8060407@gtri.gatech.edu>
In-Reply-To: <4FA21339.8060407@gtri.gatech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2012 12:10 AM, Joshua Roys wrote:


This patch is totally wrong. It is possible that there is a race condition, and 
it may be the source of the problem at
https://bugzilla.kernel.org/show_bug.cgi?id=43187, but this patch fails when the 
firmware is not cached. As a result, it prevents my box from booting.

I will try to find a fix for both conditions.

Larry

