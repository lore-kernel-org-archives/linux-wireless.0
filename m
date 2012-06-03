Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:55504 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab2FCQjl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2012 12:39:41 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SbDq7-0004C1-Rz
	for linux-wireless@vger.kernel.org; Sun, 03 Jun 2012 18:39:39 +0200
Received: from localhost ([::1]:49312 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SbDq7-0000Ai-L4
	for linux-wireless@vger.kernel.org; Sun, 03 Jun 2012 18:39:39 +0200
Received: from [195.4.92.18] (port=57545 helo=8.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SbDnU-0007w5-TA
	for linux-wireless@vger.kernel.org; Sun, 03 Jun 2012 18:36:56 +0200
Received: from [2002:4fde:120e:2:5054:ff:feb8:40bd] (port=54823 helo=mail.maya.org)
	by 8.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SbDnU-00063A-I0
	for linux-wireless@vger.kernel.org; Sun, 03 Jun 2012 18:36:56 +0200
Message-ID: <4FCB929B.7000802@01019freenet.de> (sfid-20120603_183945_508115_56AE1DB7)
Date: Sun, 03 Jun 2012 18:36:43 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Vilius Palme <palme3000@gmail.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	helmut.schaa@googlemail.com, IvDoorn@gmail.com, gwingerde@gmail.com
Subject: Re: RT2800USB driver problem. txpower stuck at 0
References: <CAOUATobNS0XNp6e+-W6VrShXpm2JVVeGUBSKxe9v05M3e00S4g@mail.gmail.com>
In-Reply-To: <CAOUATobNS0XNp6e+-W6VrShXpm2JVVeGUBSKxe9v05M3e00S4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vilius,

Vilius Palme wrote:
> Hello.
> 
> I'm having some sort of a problem with RT3070 usb dongle. It works
> perfectly fine under 3.3.5 and 3.3.7 kernels, but somewhy refuses to
> set txpower under 3.4.0. kernel .config is the same across all three.
> 
> Here's some output:
> 
> [root@R1 iw]# ifconfig wlan0 up
> [root@R1 iw]# iwconfig wlan0
> wlan0     IEEE 802.11bgn  ESSID:off/any
>          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm
>          Retry  long limit:7   RTS thr:off   Fragment thr:off
>          Encryption key:off
>          Power Management:off
> 
> [root@R1 iw]# iwconfig wlan0 txpower 20
> Error for wireless request "Set Tx Power" (8B26) :
>    SET failed on device wlan0 ; Invalid argument.
> [root@R1 iw]# iwconfig wlan0 txpower 1
> Error for wireless request "Set Tx Power" (8B26) :
>    SET failed on device wlan0 ; Invalid argument.
> [root@R1 iw]# iwconfig wlan0 txpower 0
> [root@R1 iw]#

Please take a look at this thread:
http://thread.gmane.org/gmane.comp.embedded.openwrt.devel/14224/focus=91183

Does this answer your question?


Kind regards,
Andreas
