Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49443 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2KHLQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 06:16:58 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1470656eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 03:16:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <509B73D5.5000206@mac.com>
References: <509B73D5.5000206@mac.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 8 Nov 2012 22:16:37 +1100
Message-ID: <CAGRGNgUB_7NZTnC2k2_f0_bAP0yu4cXTqk3_QpxpKZHqw__+hw@mail.gmail.com> (sfid-20121108_121711_327185_DD631123)
Subject: Re: "mac80211.ko" and "cfg80211.ko" compatibility issue.
To: Akira Nonaka <nonaka@mac.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Nov 8, 2012 at 7:56 PM, Akira Nonaka <nonaka@mac.com> wrote:
> Hi all,
>
> I have a problem with the compat-wireless. It seems "mac80211.ko" and
> "cfg80211.ko" are not compatible with the ones in main line kernel. In
> my case, it is kernel 3.4.9(Fedora 16).

This is expected and pretty much by design.

> I want to use  compat-wireless version of "mac80211.ko" and
> "cfg80211.ko" for Realtek rtl8723ae but for other wireless cards, I want
> to use main line kernel version of "mac80211.ko" and "cfg80211.ko".

Why? Are the drivers for these other cards not available in compat-wireless?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
