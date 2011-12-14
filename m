Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45833 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab1LNE5q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 23:57:46 -0500
Received: by ghbz12 with SMTP id z12so332470ghb.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 20:57:45 -0800 (PST)
Message-ID: <4EE82CC6.2030307@lwfinger.net> (sfid-20111214_055750_694987_EB447382)
Date: Tue, 13 Dec 2011 22:57:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
References: <20111118225422.GD19138@thinkpad-t410> <4EC88F58.1080203@lwfinger.net> <20111121181350.GC6736@thinkpad-t410> <4ECA99CC.7020008@lwfinger.net> <20111121185610.GD6736@thinkpad-t410> <4ECB028E.3030809@lwfinger.net> <20111122022008.GA17661@thinkpad-t410> <20111213194231.GA30788@thinkpad-t410> <4EE7B85E.3070802@lwfinger.net> <20111213212606.GB30788@thinkpad-t410>
In-Reply-To: <20111213212606.GB30788@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seth,

On 12/13/2011 03:26 PM, Seth Forshee wrote:
>
> The capture files are available at:
>
> http://people.canonical.com/~sforshee/rtl8188ce/

The major difference is that the "bad" AP implements 802.11n HT40 technology, 
but the "good" one does not.

There was a period when rtl8192ce and rtl8192cu had a bug that prevented them 
from associating with 802.11n APs, but that was fixed a long time ago. I can 
communicate with my Netgear WNDR3300 AP that implements full 802.11 capabilities.

What kernel are you running? If you implement the bleeding-edge compat-wireless 
release, does that help.

Larry
