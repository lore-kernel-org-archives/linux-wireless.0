Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail10.dslextreme.com ([66.51.199.98]:49970 "HELO
	mail10.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754906Ab0DCUDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 16:03:34 -0400
Message-ID: <4BB79F15.2040307@gmail.com>
Date: Sat, 03 Apr 2010 13:03:33 -0700
From: Gus Wirth <gwirth79@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: RTL 8187b - naughty behaviour
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com> <4BB7660A.3030900@lwfinger.net>
In-Reply-To: <4BB7660A.3030900@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2010 09:00 AM, Larry Finger wrote:
[snip]
> finger@larrylap:~> iwconfig wlan3
> wlan3     IEEE 802.11bg  ESSID:"lwfdjf_rad"
>           Mode:Managed  Frequency:2.412 GHz  Access Point: 00:14:BF:85:49:FA
>           Bit Rate=11 Mb/s   Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=69/70  Signal level=-41 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
[snip]
> At my usual distance of 2 m from the AP, the transmit rate is about 13
> Mb/s and the reported signal level is -23 dBm, about what you report.
> Our chips are different, but that has not previously been a problem.

How is it that you get a reported Bit Rate of 11Mbps from iwconfig but
your actual measured bitrate is about 13Mbps? Is there something wrong
with the way iwconfig reports what's going on? Or is there some
compression going on that is not accounted for?

Gus
