Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62776 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1LMEY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 23:24:59 -0500
Received: by ghbz12 with SMTP id z12so56893ghb.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 20:24:58 -0800 (PST)
Message-ID: <4EE6D3A0.8030907@lwfinger.net> (sfid-20111213_052519_399783_3455BECD)
Date: Mon, 12 Dec 2011 22:25:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Franky Lin <frankyl@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/15] brcm80211: the rest of smac bcma switch series
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2011 05:14 PM, Franky Lin wrote:
> Hi John,
>
> This train contains the rest of patch series switching brcmsmac to use
> bcma bus interface.
> It depends on the following patch set:
> [PATCH 00/23] brcm80211: fullmac 4430 support and softmac switch to bcma
> Message-ID:<1323385619-7454-1-git-send-email-frankyl@broadcom.com>

With this set of patches, my BCM43224 works with brcmsmac.

Larry
