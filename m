Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail120.messagelabs.com ([216.82.250.83]:65074 "EHLO
	mail120.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1JQUaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 16:30:25 -0400
Received: from il27exr02.cig.mot.com (il27exr02.mot.com [10.17.196.71])
	by motgate3.mot-solutions.com (8.14.3/8.14.3) with ESMTP id p9HKUNO9023193
	for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 13:30:24 -0700 (MST)
Received: from il27exr02.cig.mot.com (il27vts01.cig.mot.com [10.17.196.85])
	by il27exr02.cig.mot.com (8.13.1/Vontu) with ESMTP id p9HKTN2O013761
	for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 15:29:23 -0500 (CDT)
Received: from ct11exm65.ds.mot.com (ct11exm65.am.mot.com [10.177.8.53])
	by il27exr02.cig.mot.com (8.13.1/8.13.0) with ESMTP id p9HKTMfD013756
	for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 15:29:22 -0500 (CDT)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: 802.11d power control of the
Date: Mon, 17 Oct 2011 16:29:00 -0400
Message-ID: <4FAA3D750B50F245954503D85CC76B2D07D376A8@ct11exm65.ds.mot.com> (sfid-20111017_223029_503606_288207ED)
In-Reply-To: <4E9C8F77.9040406@lwfinger.net>
References: <4FAA3D750B50F245954503D85CC76B2D07D3768B@ct11exm65.ds.mot.com> <4E9C8F77.9040406@lwfinger.net>
From: "Brown Patrick-PMH786" <Patrick.Brown@motorolasolutions.com>
To: <linux-wireless@vger.kernel.org>,
	"Anthony Gray" <anthonyg@ips-yes.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sirs,

Larry Finger referred me your email address can you address the question
below please.

I am looking at the code in the linux wireless driver and trying to 
 determine if the maximum transmit power from a client is read from the 
 802.11d beacon field [the 802.11d triplet of start channel ,number of 
 channels and txpower] or is it predetermined in the software based on
the country code.

 linux-2.6.39.4\drivers\net\wireless\rtlwifi\rtl8192cu\rf.c

 My goal is from the beacons 802.11d to directly control the output 
 transmit power of a client radio.

Pat Brown,
Motorola Solutions
1 Motorola Plaza place
Holtsville , New York,
11742 
6318801188
-----Original Message-----
From: Larry Finger [mailto:larry.finger@gmail.com] On Behalf Of Larry
Finger
Sent: Monday, October 17, 2011 4:27 PM
To: Brown Patrick-PMH786
Subject: Re: 802.11d power control of the

On 10/17/2011 03:10 PM, Brown Patrick-PMH786 wrote:
> Mr Finger,
>
> I am looking at the code in the linux wireless driver and trying to
determine if
> the maximum transmit power from a client is read from the 802.11d
beacon field
> [the 802.11d triplet of start channel ,number of channels and txpower]
or is it
> predetermined in the software based on the country code.
>
> linux-2.6.39.4\drivers\net\wireless\rtlwifi\rtl8192cu\rf.c
>
> My goal is from the beacons 802.11d to directly control the output
transmit
> power of a client radio.

All of the Linux wireless drivers that use mac80211 get the maximum
power from 
the regulatory information. To my knowledge, none of them use 802.11d
beacons to 
further reduce the max power, but I am not an expert on mac80211. You
should 
address that question to linux-wireless@vger.kernel.org.

Larry

