Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa002msb.fastweb.it ([85.18.95.81]:39044 "EHLO
	aa002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYLZRGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 12:06:16 -0500
Received: from [192.168.1.101] (39.234.158.229) by aa002msb.fastweb.it (8.0.013.8)
        id 493752D30515B717 for linux-wireless@vger.kernel.org; Fri, 26 Dec 2008 18:06:14 +0100
Message-ID: <49550F05.3070706@techemia.com> (sfid-20081226_180620_246311_AD8CAA82)
Date: Fri, 26 Dec 2008 18:06:13 +0100
From: techmin <info@techemia.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 4965agn disassociating by local choice (reason=3)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please note:
Problem on kernel 2.6.27-7/9/10
with compat wireless 2008-12-11 and last compat wireless 2008-12-26
i use wep.

[ 2807.093457] wlan0: direct probe to AP XX:XX:4b:15:a5:a0 try 
1                                                       
[ 2807.095392] wlan0 direct probe 
responded                                                                             

[ 2807.095403] wlan0: authenticate with AP 
XX:XX:4b:15:a5:a0                                                            

[ 2807.097198] wlan0: 
authenticated                                                                                     

[ 2807.097208] wlan0: associate with AP 
XX:XX:4b:15:a5:a0                                                               

[ 2807.099484] wlan0: RX AssocResp from XX:XX:4b:15:a5:a0 (capab=0x431 
status=0 aid=3)                                 
[ 2807.099493] wlan0: 
associated                                                                                        

[ 2807.120643] wlan0: disassociating by local choice (reason=3)

and wireless not work (ping ap non working and connection is down).

iwlist wlan0 scan found the wireless network.
