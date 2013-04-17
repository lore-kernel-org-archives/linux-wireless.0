Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:54344 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966624Ab3DQOpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 10:45:24 -0400
Received: by mail-vc0-f171.google.com with SMTP id ha12so1373872vcb.16
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 07:45:23 -0700 (PDT)
Message-ID: <516EB581.9080602@lwfinger.net> (sfid-20130417_164529_311971_3D663800)
Date: Wed, 17 Apr 2013 09:45:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joelle <JoelleEmmily@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187 in master mode with hostapd
References: <20120727171137.4a1d1ce7@homerow> <501405FA.3070504@lwfinger.net> <20120728211613.45ca10fa@homerow> <5016A5D3.10301@lwfinger.net> <loom.20130417T144556-632@post.gmane.org>
In-Reply-To: <loom.20130417T144556-632@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2013 07:51 AM, Joelle wrote:
>
> The statement that the rtl8187 CANNOT be set as an AP is utterly wrong. Alfa
> networks provides a Windows utility that allows one to setup an AP, I've
> used it and it works(as well as anything on windows). It seems that this is
> a crime against technology that windows can provide a functionality that
> Linux cannot or may never.

I did not say that the RTL8187{B,L} cannot be used as an AP! I said that rtl8187 
cannot. The capitalization is important. With caps, it refers to a device; 
without implies a driver.

I am not sure how well an RTL8187L would work as it only has a single transmit 
queue, but perhaps it would work.

If you think there is a "crime against technology", then you need to be the one 
to make the necessary changes to rtl8187. After all, the source is open.

Larry

