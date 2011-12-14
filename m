Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51014 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1LNVWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 16:22:51 -0500
Received: by wgbdr13 with SMTP id dr13so2470181wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 13:22:50 -0800 (PST)
Message-ID: <4EE913A7.60708@lwfinger.net> (sfid-20111214_222254_843288_0E00D64F)
Date: Wed, 14 Dec 2011 15:22:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Some funny code in brcmsmac
References: <4EE823C0.7080205@lwfinger.net> <4EE9036A.7000309@broadcom.com>
In-Reply-To: <4EE9036A.7000309@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/2011 02:13 PM, Arend van Spriel wrote:

> Yep. That looks pretty useless to me ;-) I will send a code-redux patch
> for this. Feel free to share these kind of observations in a patch email
> (so I can remain my lazy self and ack it ;-) ).

OK. Actually, a patch would have been easier than a big edit on a 
copy-and-paste. My only problem was whether the code that was specific to the 
conditions was better, of if it is correct to always use the maximum power.

Larry
