Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4487 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab2C0Qu3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 12:50:29 -0400
Message-ID: <4F71EFCC.5030300@broadcom.com> (sfid-20120327_185035_223328_BD3F6821)
Date: Tue, 27 Mar 2012 18:50:20 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Naveen Goswamy" <naveen.goswamy@polymtl.ca>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac not working well
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/2012 04:53 PM, Naveen Goswamy wrote:
 > I have the BCM4313 [14e4:4727] (rev 01)
 >
 > When using wireshark, I see that I am getting many {TCP 
Retransmission,TCP Dup
 > ACK,TCP RST} with {TCP, HTTP, SSH} when using brcmsmac driver in the 
3.2.1
 > kernel.  I've tried 3.3-rc5 kernel with similar results.
 >
 > I notice a lot of these popping up in /var/log/messages as well:
 >
 > ieee80211 phy0: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 
155/256 dur
 > 1746/1504
 > ieee80211 phy0: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 
130/256 dur
 > 1546/1504
 > ieee80211 phy0: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 
130/256 dur
 > 1546/1504
 >
 >
 > any ideas how to solve this?
Starting a new thread (I hope)

These messages are only indicating (possible) violation of the WMM txop 
parameter. So what problem are you looking into here beside the issues 
you observe in wireshark. I mean the problem that made you decide to run 
wireshark.

Gr. AvS

