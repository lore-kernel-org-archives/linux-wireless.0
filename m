Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46017 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab2AYLUJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 06:20:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Rq0tc-0000mK-94
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 12:20:08 +0100
Received: from ewi1530.ewi.utwente.nl ([130.89.12.225])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jan 2012 12:20:08 +0100
Received: from timon by ewi1530.ewi.utwente.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jan 2012 12:20:08 +0100
To: linux-wireless@vger.kernel.org
From: Timon ter Braak <timon@terbraak.org>
Subject: Re: Realtek rtl8192se in AP mode?
Date: Wed, 25 Jan 2012 12:15:08 +0100
Message-ID: <jfoo7s$4n9$1@dough.gmane.org> (sfid-20120125_122014_213341_F55A7622)
References: <CAP6E9idrT=gu6cnKqMzVMVEXqRHdyuADgBNJTdCebt1Rf1dcfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
In-Reply-To: <CAP6E9idrT=gu6cnKqMzVMVEXqRHdyuADgBNJTdCebt1Rf1dcfg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/12/11 1:59 , Jean-Luc Duprat wrote:
> I am trying to find out whether the Realtek rtl8192se is
> known to be stable and reliable in AP mode.  It certainly
> became functional with kernel 3.0 and I can get the interface
> into master mode, but whenever I try to connect to it my laptop reports
> connection timeouts.  Digging a little more with wireshark, it
> seems that authentication packets exchanged, but no association
> packets are coming through...

I can confirm this issue. With another chip/device I have an AP running 
fine for years now, but with my new system I have been unsuccessful.
I have tried a variety of settings, and I am quite confident that it 
will not work until the driver/firmware is fixed.

Realtek just released a new driver, but until now I was unable to 
download and test it (permission denied):

http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=21&PFid=48&Level=5&Conn=4&ProdID=230&DownTypeID=3&GetDown=false&Downloads=true&SortByDesc=1

Timon

