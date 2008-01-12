Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48016 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbYALSYJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 13:24:09 -0500
Message-ID: <478905B9.3080004@hauke-m.de> (sfid-20080112_182431_151424_5CA8C021)
Date: Sat, 12 Jan 2008 19:23:53 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8187 rate control doesn't work
References: <477F9890.5050107@hauke-m.de>	<43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>	<47824D25.5090005@hauke-m.de>	<43e72e890801070942y5abcc8acs31ac446d67414483@mail.gmail.com>	<4787F03E.6080605@hauke-m.de>	<4788D24E.30805@hauke-m.de> <20080112162121.2fc2f507@morte>
In-Reply-To: <20080112162121.2fc2f507@morte>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have tried wireless-2.6 and I have the same problem. If the rate goes
over 11M no TCP/IP traffic goes through the wireless connecting. If rate
is set to auto and the rate control algorithm changes it to something
less than 11M TCP/IP traffic goes through, but if it is more than 11M no
TCP/IP traffic goes through the wireless link.

with "iwconfig wlan0 rate 11M" everything works.

--
Hauke Mehrtens

Stefano Brivio wrote:
> On Sat, 12 Jan 2008 15:44:30 +0100
> Hauke Mehrtens <hauke@hauke-m.de> wrote:
> 
>> I have tested kernel 2.6.24-rc7-git4 with the build in rtl8187 module
>> and I have the same problem.
> 
> Could you please try the wireless-2.6 kernel tree? I think it's fixed
> there. Details on how to download that can be found here:
> http://linuxwireless.org/en/developers/Documentation/git-guide
> 
> 
> --
> Ciao
> Stefano
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
