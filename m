Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12875 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbYJaDK7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 23:10:59 -0400
Message-ID: <20081030231054.ehd21qipcow4kg88-cebfxv@webmail.spamcop.net> (sfid-20081031_041103_396953_8772C582)
Date: Thu, 30 Oct 2008 23:10:54 -0400
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dave <kilroyd@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: Guidelines regarding separate directory
References: <4909EA78.3060700@lwfinger.net>
	(sfid-20081030_181107_189082_5740895D)
	<1225387309.3690.73.camel@johannes.berg> <490A17F3.5050802@gmail.com>
	<1225399481.7931.5.camel@dv> <1225399682.3690.82.camel@johannes.berg>
In-Reply-To: <1225399682.3690.82.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Johannes Berg <johannes@sipsolutions.net>:

>
>> > orinoco_pci.c
>>
>> orinoco_pci.c is a good candidate for removal.  It only supports the
>> hardware that is already supported by hostap_pci.
>
> Wait wait. I think everybody would rather see hostap go than orinoco
> since hostap is a huge complex thing and quite buggy.

The WPA support in orinoco is limited to Agere firmware.  Maybe Symbol  
firmware will be supported at some point.  But adding WPA support for  
Intersil firmware would duplicate efforts.

The only thing I would like to change in hostap is that it should  
default to managed mode, like other drivers do.

But since there are objections, let's keep orinoco_pci as long as it  
doesn't stand in the way of further changes.

-- 
Regards,
Pavel Roskin
