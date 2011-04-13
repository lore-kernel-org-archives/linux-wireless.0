Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65393 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab1DMKPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 06:15:11 -0400
Received: by fxm17 with SMTP id 17so333047fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2011 03:15:10 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Damian Lesiuk <lesiuk@gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps) MASTER MODE
Date: Wed, 13 Apr 2011 12:14:53 +0200
Cc: linux-wireless@vger.kernel.org
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
In-Reply-To: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201104131214.53633.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 13 April 2011 10:33:38 Damian Lesiuk wrote:
> I have very low connection speeds. Is it normal for that device/driver?

depends, mostly on the client and maybe interference/link quality.
<http://wireless.kernel.org/en/users/Drivers/carl9170#A802.11n_Compatibility>


you probably have to enable wmm [see hostapd docs], but because of the
compatibility issues anyone should refrain from

however, Atheros has just released a patchset+fw which brings AP
support to ath9k_htc.
