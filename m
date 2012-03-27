Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1414 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab2C0RIH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 13:08:07 -0400
Message-ID: <4F71F3E5.6030105@broadcom.com> (sfid-20120327_190811_297368_2E704237)
Date: Tue, 27 Mar 2012 19:07:49 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Naveen Goswamy" <naveen.goswamy@polymtl.ca>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac TCP problems and txop exceeded
References: <1332866581.4f71ee152ce84@www.imp.polymtl.ca>
In-Reply-To: <1332866581.4f71ee152ce84@www.imp.polymtl.ca>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/2012 06:43 PM, Naveen Goswamy wrote:
> Hi, this thread should be a continuation of one I started about a month ago and
> can be found here:
>
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/86324
>
> (I lost the header to it and inadvertantly cross posted into another thread, my
> apologies for that)
>
>
>
> So here goes:
>
> I have the BCM4313 [14e4:4727] (rev 01)
>
> When using wireshark, I see that I am getting many {TCP Retransmission,TCP Dup
> ACK,TCP RST} with {TCP, HTTP, SSH} when using brcmsmac driver in the 3.2.1
> kernel.  I've tried 3.3-rc5 kernel with similar results.
>
> I notice a lot of these popping up in /var/log/messages as well:
>
> ieee80211 phy0: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 155/256 dur
> 1746/1504
> ieee80211 phy0: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 130/256 dur
> 1546/1504
> ieee80211 phy0: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 130/256 dur
> 1546/1504
>
>
> any ideas how to solve this?
>

These messages are only indicating (possible) violation of the WMM txop
parameter. So what problem are you looking into here beside the issues
you observe in wireshark. I mean the problem that made you decide to run 
wireshark.

Gr. AvS



