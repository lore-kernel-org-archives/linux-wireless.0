Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33870 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbcDZI4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:56:11 -0400
Received: by mail-qk0-f176.google.com with SMTP id r184so2862138qkc.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 01:56:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
References: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
Date: Tue, 26 Apr 2016 02:56:10 -0600
Message-ID: <CAAA5faGpa9ePaZagPpNaXdXz8FZrsDr=M4pMGEVO6F3xUc+aZA@mail.gmail.com> (sfid-20160426_105622_788471_B17C5A90)
Subject: Re: Intel 7260 AC only using 802.11n not AC
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
To: Radu P <rrrpan@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm also using the 7620 AC.
When I type:

sudo iw dev wlp0s4 scan I see:

reinoud@router-dev:~/openwrt$ sudo iw dev wlp4s0 scan
BSS 00:30:44:1d:cf:2b(on wlp4s0) -- associated
[SNIP]
        VHT capabilities:
               VHT Capabilities (0x31c12820):
                       Max MPDU length: 3895
                       Supported Channel Width: neither 160 nor 80+80
                       short GI (80 MHz)
                       SU Beamformer
                       +HTC-VHT
                       RX antenna pattern consistency
                       TX antenna pattern consistency
               VHT RX MCS set:
                       1 streams: MCS 0-9
                       2 streams: MCS 0-9
                       3 streams: not supported
                       4 streams: not supported
                       5 streams: not supported
                       6 streams: not supported
                       7 streams: not supported
                       8 streams: not supported
               VHT RX highest supported: 780 Mbps
               VHT TX MCS set:
                       1 streams: MCS 0-9
                       2 streams: MCS 0-9
                       3 streams: not supported
                       4 streams: not supported
                       5 streams: not supported
                       6 streams: not supported
                       7 streams: not supported
                       8 streams: not supported
               VHT TX highest supported: 780 Mbps
       VHT operation:
                * channel width: 0 (20 or 40 MHz)
                * center freq segment 1: 0
                * center freq segment 2: 0
                * VHT basic MCS set: 0xfffa
       WPS:     * Version: 1.0
                * Wi-Fi Protected Setup State: 2 (Configured)
                * Response Type: 3 (AP)
                * UUID: bc329e00-1dd8-11b2-8601-0030441dcf2b
                * Manufacturer: Cradlepoint Technology
                * Model: Cradlepoint Access Point
                * Model Number: CPDEV
                * Serial Number: 12345678
                * Primary Device Type: 6-0050f204-1
                * Device name: CradlepointAP
                * Config methods: Label, PBC
                * RF Bands: 0x2

Hence, my 7620 does support 11c.
 [    9.704827] iwlwifi 0000:04:00.0: loaded firmware version
16.242414.0 op_mode iwlmvm
 [    9.840382] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
Wireless AC 7260, REV=0x144
 [    9.840428] iwlwifi 0000:04:00.0: L1 Disabled - LTR Enabled
 [    9.840657] iwlwifi 0000:04:00.0: L1 Disabled - LTR Enabled

On Tue, Apr 26, 2016 at 1:20 AM, Radu P <rrrpan@gmail.com> wrote:
> Hello,
>
> These is the relevant data:
>
> firmware-version: 17.265642.0
>
> [  292.689871] iwlwifi 0000:04:00.0: loaded firmware version
> 17.265642.0 op_mode iwlmvm
> [  292.702902] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
> Wireless AC 7260, REV=0x144
>
> wlan1     IEEE 802.11abgn <- not AC
>
> Kernel version: 4.4.0-21-generic #37~14.04.1-Ubuntu
>
> AC mode is working with Windows 10.
>
> Any help is appreciated!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
