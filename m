Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.236]:1277 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbXFNJqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 05:46:14 -0400
Received: by wr-out-0506.google.com with SMTP id 76so438163wra
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2007 02:46:13 -0700 (PDT)
Message-ID: <a32f33a40706140246h3d0d32c2q414c5782941e262b@mail.gmail.com>
Date: Thu, 14 Jun 2007 11:46:12 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: rt2x00firmware.c missing some include
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1181770871.29767.139.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <1181770871.29767.139.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I get
>
>   CC [M]  drivers/net/wireless/mac80211/rt2x00/rt2x00firmware.o
> drivers/net/wireless/mac80211/rt2x00/rt2x00firmware.c: In function
> 'rt2x00lib_load_firmware_wait':
> drivers/net/wireless/mac80211/rt2x00/rt2x00firmware.c:123: warning: implicit
> declaration of function 'msleep'
>
> on powerpc. I suppose on your system something pulls in the relevant
> header already.

John already committed a fix for this to wireless-dev :)
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-dev.git;a=commit;h=9181e959da76d85d688d8ec763702ed2f3b4edf9

Ivo
