Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41477 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab2AEI1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 03:27:10 -0500
Received: by vcbfk14 with SMTP id fk14so211287vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jan 2012 00:27:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHzJmyaXGpZO3TFaMwqKZaYwO4brtxWENoekvGSdo20UVdUVZg@mail.gmail.com>
References: <CAHzJmyaXGpZO3TFaMwqKZaYwO4brtxWENoekvGSdo20UVdUVZg@mail.gmail.com>
Date: Thu, 5 Jan 2012 13:57:09 +0530
Message-ID: <CAD2nsn2zYWFG_N+tJohh9DwBHmaVJ6ZkyYgh8LAK81=Sws5e=g@mail.gmail.com> (sfid-20120105_092715_927048_50B6992A)
Subject: Re: ath9k_htc.ko
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Linx Zhang <linx.zhang@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 5, 2012 at 1:00 PM, Linx Zhang <linx.zhang@gmail.com> wrote:
> All,
>
> Anyone knows how to setup Atheros USB wifi card(TP-LINK WN821N) as AP
> mode on the linux (Ubuntu 11.10)? I have tested below commands, but
> failed:

please use
http://linuxwireless.org/en/users/Documentation/hostapd
http://linuxwireless.org/en/users/Download/stable#compat-wireless_3.2_stable_releases

>
> mypromp#iwconfig
> wlan0     IEEE 802.11bgn  ESSID:off/any
>          Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
>          Retry  long limit:7   RTS thr:off   Fragment thr:off
>          Encryption key:off
>          Power Management:off
>
> mypromp#/wlanconfig ath create wlandev wlan0 wlanmode ap
> wlanconfig: ioctl: Operation not supported
>
> mypromp# lsmod
> Module                  Size  Used by
> ath9k_htc              51280  0
> ath9k_common            1661  1 ath9k_htc
> ath9k_hw              335589  2 ath9k_htc,ath9k_common
> ath                    13592  3 ath9k_htc,ath9k_common,ath9k_hw
> mac80211              224045  1 ath9k_htc
> cfg80211              151788  3 ath9k_htc,ath,mac80211
> compat                 15880  3 ath9k_htc,mac80211,cfg80211
> rfkill                 14626  1 cfg80211
>
> mypromp# lsusb
> Bus 001 Device 007: ID 0cf3:7015 Atheros Communications, Inc.
>
> Any comments or helps will be appreciated!
>
> Thanks.
>
> Morris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
shafi
