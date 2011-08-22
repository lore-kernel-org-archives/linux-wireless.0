Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4947 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab1HVGwb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 02:52:31 -0400
Message-ID: <4E51FCA3.9020405@broadcom.com> (sfid-20110822_085234_565800_F1A08204)
Date: Mon, 22 Aug 2011 08:52:19 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Dan Williams" <dcbw@redhat.com>
cc: =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Subject: Re: brcmsmac driver only works when sitting next to the AP
References: <20110814121646.GA5188@stt008.linux.site>
 <4E4A5641.4020604@broadcom.com>
 <1313509211.2065.36.camel@dcbw.foobar.com>
 <4E4B9A45.5090507@broadcom.com> <4E4CC85A.7010504@broadcom.com>
 <4E4E73F4.4040105@broadcom.com>
 <1313786823.4810.13.camel@dcbw.foobar.com>
In-Reply-To: <1313786823.4810.13.camel@dcbw.foobar.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I do not channel work email to a Blackberry.  Chill out.

You are right, I was too impatient. I am sorry for that.

> The error about supplicant manager state is not important, as the
> supplicant later transitions to idle/ready state and NM proceeds.  What
> *is* important is the inability of the driver to perform scans, which
> means that no scan list is available for the supplicant to work with,
> and thus it cannot associate with any known AP.  What we want now is
> driver debugging information about *why* the driver refuses to perform
> scans.

Ok, now it is clear to me why the assert is not relevant. I'll dive into 
this deeper.

Thanks, Roland.

