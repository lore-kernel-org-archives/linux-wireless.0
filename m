Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35155 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0KCBoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 21:44:30 -0400
Received: by yxk8 with SMTP id 8so99647yxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 18:44:30 -0700 (PDT)
Message-ID: <4CD0BE99.8020409@lwfinger.net>
Date: Tue, 02 Nov 2010 20:44:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rogerio Luz Coelho <rogluz.news@gmail.com>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
References: <309278.75116.qm@web29520.mail.ird.yahoo.com>	<4CCF7B73.7040906@lwfinger.net>	<4CCF7EFC.1050000@mandriva.com.br>	<AANLkTinEsp+-EU4Oau71qHbL6ftO544+H4GA3WZk7CX5@mail.gmail.com>	<4CD0A583.40105@lwfinger.net>	<AANLkTin937V6hJ4L2o-SF5riTh0MpTd3e6faZnbZuV48@mail.gmail.com>	<4CD0B0AC.4050102@lwfinger.net> <AANLkTinpJSKhf9PcG9bAPsLjVRKZ3bJEEK0-UQ4rpxJH@mail.gmail.com>
In-Reply-To: <AANLkTinpJSKhf9PcG9bAPsLjVRKZ3bJEEK0-UQ4rpxJH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2010 08:06 PM, Rogerio Luz Coelho wrote:
> 
> :) My biggest issue wasn't actually doing the patch, it was actually
> compiling the damn thing on Ubuntu, that's what you get when you
> install a distro that tells you in their kernel help page that they
> don't WANT you to be able to compile your own kernel.
> 
> But as I said the connect - disconnect is gone.
> 
> I will try the new patches alone and with Cascardo's ... will post result here.

As I did something like 20 full kernel builds today, you know I do not use a
distro that actively discourages kernel compilation. In fact I did run Ubuntu
once to help a user debug a problem. After experiencing the hoops they make you
jump through, I blew it away as soon as I could.

Larry
