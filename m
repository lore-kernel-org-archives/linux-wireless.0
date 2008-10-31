Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sr02-07.mta.terra.com.br ([200.154.152.36]:45903 "EHLO
	sr02-07.mta.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYJaD3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 23:29:33 -0400
Message-ID: <490A7B94.8030107@terra.com.br> (sfid-20081031_042949_933107_1ECD4CE3)
Date: Fri, 31 Oct 2008 01:29:24 -0200
From: Piter PUNK <piterpk@terra.com.br>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: htl10@users.sourceforge.net,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] rtl8187: Change TX power settings
References: <838057.50079.qm@web23102.mail.ird.yahoo.com> <49088F7D.8020102@lwfinger.net>	<490905E9.8040005@lwfinger.net> <4909E5F6.9040401@lwfinger.net>
In-Reply-To: <4909E5F6.9040401@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> The latest vendor driver (rtl8187B_linux_26.1036.0708.2008) has changed the
> CCK and OFDM power setting code as compared with previous versions. This
> patch implements those changes for the Linux driver.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Piter,
> 
> Does this help your devices?
> 
> Larry

Yes! I apply the patch against 2.6.27.4 and is all OK -:)
Just now i upload some package files to slackware.com!

Seems to me that all the magic is:

 > +			 rtl8225z2_tx_gain_cck_ofdm[cck_power] << 1);

Correct? It only increases the TX power?

Thanks!

Piter PUNK

-- 
     |        E-Mail: piterpk@terra.com.br
    .|.
    /V\
   // \\      UIN:116043354  Homepage:http://piterpunk.info02.com.br
  /(   )\
   ^`~'^         ----> Slackware Linux <----
  #105432
