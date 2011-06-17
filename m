Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54086 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab1FQOJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 10:09:13 -0400
Received: by iwn34 with SMTP id 34so2021466iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 07:09:12 -0700 (PDT)
Message-ID: <4DFB6004.1060006@lwfinger.net> (sfid-20110617_160917_429469_F9D98751)
Date: Fri, 17 Jun 2011 09:09:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: peter@chubb.wattle.id.au
CC: linux-wireless@vger.kernel.org
Subject: Re: State of rtl8192CU driver?
References: <w4hb7ohfo5.wl%peter@chubb.wattle.id.au>
In-Reply-To: <w4hb7ohfo5.wl%peter@chubb.wattle.id.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/17/2011 06:15 AM, peter@chubb.wattle.id.au wrote:
>
> Hi.
> 	I'm trying out the rtl8192CU driver with an edimax wireless N
> 	dongle.  The driver loads correctly, and wpa_supplicant can
> 	trigger an association with an access point, using WPA2/PEAP.
> 	I'm using the tip of Linus's kernel tree (3.0.0-rc2)
>
> 	But the interface then does nothing:  it doesn't pick up an
> 	ipv6 address from radvd broadcasts, nor does it appear to send
> 	any dhcp requests, even though the TX packet counter increases.
>
> 	
> 	Do you have any ideas about how I could debug this?

You should inspect the output from dmesg to see if anything is reported. In 
addition, use wireshark to see what is on the air.

What kind of connection is being tried?

Larry
