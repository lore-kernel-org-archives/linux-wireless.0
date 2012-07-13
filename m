Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43502 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab2GMVQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 17:16:24 -0400
Received: by weyx8 with SMTP id x8so2758110wey.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2012 14:16:23 -0700 (PDT)
Message-ID: <50009024.4080607@gmail.com> (sfid-20120713_231628_990941_D245C7F7)
Date: Fri, 13 Jul 2012 23:16:20 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP v2] rtlwifi: rtl8192su subdriver
References: <4FEF0BD1.90405@gmail.com> <4FFAD137.3020806@gtri.gatech.edu>
In-Reply-To: <4FFAD137.3020806@gtri.gatech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 02:40 PM, Joshua Roys wrote:

> Currently I'm still searching for the hidden/undocumented registers that will
 > allow the rtlwifi driver to drive the *su chips.  (The rtlwifi driver uses the
 > softmac infrastructure while the current firmware for the *su chips really
 > needs a fullmac driver.)

Is there any reason to think a fullmac driver is better than a softmac for this chip ?
